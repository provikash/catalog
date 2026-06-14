import 'package:catalog/core/themes/theme.dart';
import 'package:catalog/views/screens/product_list/widgets/error_view.dart';
import 'package:catalog/views/screens/product_list/widgets/filter_chip.dart';
import 'package:catalog/views/screens/product_list/widgets/product_grid.dart';
import 'package:catalog/views/screens/wishlist/wishlist_screen.dart';
import 'package:catalog/views/screens/product_list/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/product_notifier.dart';

import 'widgets/filter_bottom_sheet.dart';
import '../product_detail/product_detail_screen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).loadProducts();
      ref.read(productProvider.notifier).loadCategories();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(productProvider.notifier).loadMore();
    }
  }

  void _openFilter(BuildContext context) {
    final state = ref.read(productProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        categories: state.categories.map((c) => c.slug).toList(),
        selectedCategory: state.selectedCategory,
        priceRange: RangeValues(state.minPrice, state.maxPrice),
        maxPrice: state.absoluteMaxPrice,
        onCategoryChanged: (cat) {
          ref.read(productProvider.notifier).filterByCategory(cat);
        },
        onPriceRangeChanged: (range) {
          ref
              .read(productProvider.notifier)
              .filterByPrice(range.start, range.end);
        },
        onApply: () {},
        onReset: () {
          ref.read(productProvider.notifier).resetFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover',
                            style: AppTextStyles.heading.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${state.totalCount} products found',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),

                      // Wishlist icon
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WishlistScreen(),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(
                                Icons.favorite_outline_rounded,
                                size: 24,
                              ),
                              if (state.wishlistCount > 0)
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      color: AppColors.accent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${state.wishlistCount}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  ProductSearchBar(
                    onSearch: (query) {
                      ref.read(productProvider.notifier).search(query);
                    },
                    onFilterTap: () => _openFilter(context),
                  ),

                  // ── Active filter chips ──────
                  if (state.isFiltered) ...[
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (state.selectedCategory != null)
                            ActiveFilterChip(
                              label: state.selectedCategory!,
                              onRemove: () => ref
                                  .read(productProvider.notifier)
                                  .filterByCategory(null),
                            ),
                          if (state.minPrice > 0 ||
                              state.maxPrice < state.absoluteMaxPrice)
                            ActiveFilterChip(
                              label:
                                  '₹${state.minPrice.toStringAsFixed(0)}–₹${state.maxPrice.toStringAsFixed(0)}',
                              onRemove: () => ref
                                  .read(productProvider.notifier)
                                  .resetFilters(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Content ─────────────────────────
            Expanded(
              child: state.error != null
                  ? ErrorView(
                      message: state.error!,
                      onRetry: () =>
                          ref.read(productProvider.notifier).loadProducts(),
                    )
                  : ProductGrid(
                      products: state.isLoading && state.products.isEmpty
                          ? List.generate(10, (index) => null)
                          : state.products,

                      isInitialLoading:
                          state.isLoading && state.products.isEmpty,
                      isLoadingMore: state.isLoadingMore,
                      scrollController: _scrollController,
                      wishlisted: state.wishlistedIds,
                      onTap: (product) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      onWishlistTap: (product) {
                        ref
                            .read(productProvider.notifier)
                            .toggleWishlist(product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
