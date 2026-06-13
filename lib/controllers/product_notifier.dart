import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/dio_client.dart';
import '../services/api_service.dart';
import '../models/product_models.dart';
import 'product_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────
//  Provider
// ─────────────────────────────────────────
final productProvider = NotifierProvider<ProductNotifier, ProductState>(
  ProductNotifier.new,
);

// ─────────────────────────────────────────
//  Notifier
// ─────────────────────────────────────────
class ProductNotifier extends Notifier<ProductState> {
  final _apiService = ApiService(DioClient().dio);

  static const int _limit = 20;

  Timer? _debounce;

  @override
  ProductState build() {
    _clearOldWishlist();
    _loadWishlist();
    return const ProductState();
  }

  // ── 1. Initial Load ───────────────────
  Future<void> loadProducts() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      skip: 0,
      products: [],
      hasMore: true,
      searchQuery: '',
      selectedCategory: null,
    );

    try {
      final response = await _apiService.getProducts(limit: _limit, skip: 0);

      state = state.copyWith(
        isLoading: false,
        products: response.products,
        skip: response.products.length,
        hasMore: response.products.length < response.total,
      );
    } catch (e) {
      debugPrint('❌ loadProducts error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── 2. Load More (pagination) ─────────
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    // guard: don't paginate during search or category filter
    if (state.searchQuery.isNotEmpty || state.selectedCategory != null) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final response = await _apiService.getProducts(
        limit: _limit,
        skip: state.skip,
      );

      final updatedProducts = [...state.products, ...response.products];

      state = state.copyWith(
        isLoadingMore: false,
        products: updatedProducts,
        skip: updatedProducts.length,
        hasMore: updatedProducts.length < response.total,
      );
    } catch (e) {
      debugPrint('❌ loadMore error: $e');
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  // ── 3. Search (with debounce) ─────────
  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _executeSearch(query.trim());
    });
  }

  Future<void> _executeSearch(String query) async {
    // if query cleared → reload all products
    if (query.isEmpty) {
      await loadProducts();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      searchQuery: query,
      selectedCategory: null,
    );

    try {
      final response = await _apiService.searchProducts(query);

      state = state.copyWith(
        isLoading: false,
        products: response.products,
        skip: response.products.length,
        hasMore: false, // disable pagination during search
      );
    } catch (e) {
      debugPrint('❌ search error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── 4. Filter by Category ─────────────
  Future<void> filterByCategory(String? category) async {
    // if same category tapped again → reset
    if (category == null || category == state.selectedCategory) {
      await loadProducts();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedCategory: category,
      searchQuery: '',
      products: [],
    );

    try {
      final response = await _apiService.getProductsByCategory(category);

      state = state.copyWith(
        isLoading: false,
        products: response.products,
        skip: response.products.length,
        hasMore: false, // disable pagination during category filter
      );
    } catch (e) {
      debugPrint('❌ filterByCategory error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── 5. Load Categories ────────────────
  Future<void> loadCategories() async {
    try {
      final categories = await _apiService.getCategories();
      state = state.copyWith(categories: categories);
    } catch (e) {
      debugPrint('❌ loadCategories error: $e');
      // non-critical — don't set error state for this
    }
  }

  // ── 6. Reset all filters ──────────────
  Future<void> resetFilters() async {
    await loadProducts();
  }

  Future<void> filterByPrice(double min, double max) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      minPrice: min,
      maxPrice: max,
    );

    try {
      final response = await _apiService.getProducts(limit: _limit, skip: 0);

      // filter locally after fetch
      final filtered = response.products
          .where((p) => p.price >= min && p.price <= max)
          .toList();

      state = state.copyWith(
        isLoading: false,
        products: filtered,
        hasMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── 7. Toggle Wishlist ────────────────
  void toggleWishlist(ProductModels product) {
    final current = [...state.wishlistedProducts];
    final exists = current.any((p) => p.id == product.id);

    if (exists) {
      current.removeWhere((p) => p.id == product.id);
    } else {
      current.add(product);
    }

    state = state.copyWith(wishlistedProducts: current);
    _saveWishlist(current);
  }

  // -- 8. Wishlist save to Local storage

  Future<void> _saveWishlist(List<ProductModels> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final jsonList = products
          .map((p) => jsonEncode(p.tojson())) // ✅ each product → JSON string
          .toList();

      await prefs.setStringList('wishlistKey', jsonList);
      debugPrint('✅ Saved ${products.length} wishlist items');
    } catch (e) {
      debugPrint('❌ Failed to save wishlist: $e');
    }
  }

  Future<void> _loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList('wishlistKey') ?? [];

      final products = <ProductModels>[];

      for (final jsonStr in jsonList) {
        try {
          final decoded = jsonDecode(jsonStr);
          // ✅ skip if it's not a Map (old format — plain IDs)
          if (decoded is! Map<String, dynamic>) {
            debugPrint('⚠️ Skipping invalid wishlist entry: $decoded');
            continue;
          }
          products.add(ProductModels.fromJson(decoded));
        } catch (e) {
          debugPrint('⚠️ Skipping corrupt entry: $e');
          continue; // skip bad entries, don't crash
        }
      }

      // ✅ if old format detected, clear and start fresh
      if (products.isEmpty && jsonList.isNotEmpty) {
        debugPrint('🧹 Clearing old wishlist format');
        await prefs.remove('wishlistKey');
      }

      debugPrint('✅ Loaded ${products.length} wishlist items');
      state = state.copyWith(wishlistedProducts: products);
    } catch (e) {
      debugPrint('❌ Failed to load wishlist: $e');
    }
  }

  Future<void> _clearOldWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wishlist_products');
    debugPrint('🧹 Old wishlist cleared');
  }
}
