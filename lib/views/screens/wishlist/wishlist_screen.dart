import 'package:catalog/core/themes/theme.dart';
import 'package:catalog/views/screens/wishlist/widgets/empty_wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../controllers/product_notifier.dart';
import '../../../models/product_models.dart';
import '../product_detail/product_detail_screen.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);
    final wishlisted = state.wishlistedProducts;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wishlist',
                        style: textTheme.headlineLarge?.copyWith(
                          fontSize: 24,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${wishlisted.length} item${wishlisted.length == 1 ? '' : 's'}',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: wishlisted.isEmpty
                  ? EmptyWishlist(onBrowse: () => Navigator.pop(context))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      itemCount: wishlisted.length,
                      itemBuilder: (context, index) {
                        final product = wishlisted[index];
                        return _WishlistItem(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          onRemove: () {
                            ref
                                .read(productProvider.notifier)
                                .toggleWishlist(product);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistItem extends StatefulWidget {
  final ProductModels product;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _WishlistItem({
    required this.product,
    required this.onTap,
    required this.onRemove,
  });

  @override
  State<_WishlistItem> createState() => _WishlistItemState();
}

class _WishlistItemState extends State<_WishlistItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      value: 1.0,
    );
    _scaleAnim = Tween<double>(
      begin: 0.97,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        widget.onTap();
      },
      onTapCancel: () => _controller.forward(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [


              // Image
ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: 'product-image-${widget.product.id}',
                  child: CachedNetworkImage(
                    imageUrl: widget.product.thumbnail,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, progress) => Container(
                      width: 80,
                      height: 80,
                      color: colorScheme.surfaceContainerHighest
                    ),
                    errorWidget: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: colorScheme.surfaceContainerHighest,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.wishlistInactive,
                      ),
                    ),
                  ),
                ),

),
            
              
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: AppColors.rating,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          widget.product.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₹${widget.product.discountedPrice.toStringAsFixed(0)}',
                          style: AppTextStyles.price.copyWith(
                            fontSize: 15,
                            color: colorScheme.primary,
                          ),
                        ),
                        if (widget.product.discountPercentage > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            '₹${widget.product.price.toStringAsFixed(0)}',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Remove button
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: colorScheme.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
