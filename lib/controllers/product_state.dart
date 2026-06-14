import '../models/category_model.dart';
import '../models/product_models.dart';

class ProductState {
  final List<ProductModels> products;
  final List<CategoryModel> categories;

  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String searchQuery;
  final String? selectedCategory;
  final int selectedImageIndex;

  final int skip;
  final bool hasMore;
  final double minPrice;
  final double maxPrice;
  final double absoluteMaxPrice;

  // Wishlist
  final List<ProductModels> wishlistedProducts;

  const ProductState({
    this.products = const [],
    this.categories = const [],

    this.selectedImageIndex = 0,

    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategory,
    this.skip = 0,
    this.hasMore = true,
    this.wishlistedProducts = const [],
    this.minPrice = 0,
    this.maxPrice = 10000,
    this.absoluteMaxPrice = 10000,
  });

  // Computed helpers
  Set<int> get wishlistedIds => wishlistedProducts.map((p) => p.id).toSet();

  int get wishlistCount => wishlistedProducts.length;
  int get totalCount => products.length;

  bool get isFiltered =>
      selectedCategory != null || minPrice > 0 || maxPrice < absoluteMaxPrice;

  bool isWishlisted(int productId) => wishlistedIds.contains(productId);

  ProductState copyWith({
    List<ProductModels>? products,
    List<CategoryModel>? categories,
    int? selectedImageIndex,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    String? selectedCategory,
    int? skip,
    bool? hasMore,
    List<ProductModels>? wishlistedProducts,
    double? minPrice,
    double? maxPrice,
    double? absoluteMaxPrice,
    bool clearCategory = false,
    bool clearError = false,
    bool clearSearch = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,

      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error ?? this.error,
      searchQuery: clearSearch ? '' : searchQuery ?? this.searchQuery,
      selectedCategory: clearCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      skip: skip ?? this.skip,
      hasMore: hasMore ?? this.hasMore,
      wishlistedProducts: wishlistedProducts ?? this.wishlistedProducts,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      absoluteMaxPrice: absoluteMaxPrice ?? this.absoluteMaxPrice,
    );
  }
}
