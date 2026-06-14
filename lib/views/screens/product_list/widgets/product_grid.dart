import 'package:catalog/models/product_models.dart';
import 'package:catalog/views/screens/product_list/widgets/empty_view.dart';
import 'package:catalog/views/screens/product_list/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModels?> products;

  final bool isInitialLoading;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final Set<int> wishlisted;
  final ValueChanged<ProductModels> onTap;
  final ValueChanged<ProductModels> onWishlistTap;

  const ProductGrid({super.key, 
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
      return const EmptyView();
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = products[index];
              return ProductCard(
                product: product,

                isLoading: isInitialLoading,

                isWishlisted:
                    product != null && wishlisted.contains(product.id),
                onTap: product != null ? () => onTap(product) : null,
                onWishlistTap: product != null
                    ? () => onWishlistTap(product)
                    : null,
              );
            }, childCount: products.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),
          ),
        ),
        //
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
