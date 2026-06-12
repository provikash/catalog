import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/product_notifier.dart';
import '../../models/product_models.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart';

import '../widgets/filter_bottom_sheet.dart';
import 'product_detail_screen.dart';


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
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ProductNotifier.notifier).loadProducts();
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
      ref.read(ProductNotifier.notifier).loadMore();
    }
  }

  void _openFilter(BuildContext context) {
    final state = ref.read(productControllerProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        categories: state.categories,
        selectedCategory: state.selectedCategory,
        priceRange: RangeValues(
          state.minPrice,
          state.maxPrice,
        ),
        maxPrice: state.absoluteMaxPrice,
        onCategoryChanged: (cat) {
          ref.read(productControllerProvider.notifier).filterByCategory(cat);
        },
        onPriceRangeChanged: (range) {
          ref
              .read(productControllerProvider.notifier)
              .filterByPrice(range.start, range.end);
        },
        onApply: () {},
        onReset: () {
          ref.read(productControllerProvider.notifier).resetFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onBackground,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            '${state.totalCount} products found',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Wishlist icon
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/wishlist'),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              const Icon(Icons.favorite_outline_rounded,
                                  size: 24),
                              if (state.wishlistCount > 0)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
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
                      ref
                          .read(productControllerProvider.notifier)
                          .search(query);
                    },
                    onFilterTap: () => _openFilter(context),
                  ),

                  // Active filter chips
                  if (state.selectedCategory != null ||
                      state.isFiltered) ...[
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (state.selectedCategory != null)
                            _FilterChip(
                              label: state.selectedCategory!,
                              onRemove: () => ref
                                  .read(productControllerProvider.notifier)
                                  .filterByCategory(null),
                            ),
                          if (state.isFiltered)
                            _FilterChip(
                              label:
                                  '₹${state.minPrice.toStringAsFixed(0)}–₹${state.maxPrice.toStringAsFixed(0)}',
                              onRemove: () => ref
                                  .read(productControllerProvider.notifier)
                                  .resetFilters(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Content
            Expanded(
              child: state.error != null
                  ? _ErrorView(
                      message: state.error!,
                      onRetry: () => ref
                          .read(productControllerProvider.notifier)
                          .init(),
                    )
                  : _ProductGrid(
                      products: state.isLoading && state.products.isEmpty
                          ? List.generate(10, (_) => null)
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
                            .read(productControllerProvider.notifier)
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

class _ProductGrid extends StatelessWidget {
  final List<ProductModel?> products;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final Set<int> wishlisted;
  final ValueChanged<ProductModel> onTap;
  final ValueChanged<ProductModel> onWishlistTap;

  const _ProductGrid({
    required this.products,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.scrollController,
    required this.wishlisted,
    required this.onTap,
    required this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty && !isInitialLoading) {
      return const _EmptyView();
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  isLoading: isInitialLoading,
                  isWishlisted:
                      product != null && wishlisted.contains(product.id),
                  onTap: product != null ? () => onTap(product) : null,
                  onWishlistTap:
                      product != null ? () => onWishlistTap(product) : null,
                );
              },
              childCount: products.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),
          ),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
