import 'package:catalog/core/themes/theme.dart';
import 'package:catalog/views/screens/product_detail/widgets/add_to_cart_bar.dart';
import 'package:catalog/views/screens/product_detail/widgets/info_row.dart';
import 'package:catalog/views/screens/product_detail/widgets/product_image_gallery.dart';
import 'package:catalog/views/screens/product_detail/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/product_models.dart';
import '../../../controllers/product_notifier.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModels product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    );
    _fabScale = _fabController.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _animateFab() async {
    await _fabController.reverse();
    await _fabController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final state = ref.watch(productProvider);
    final isWishlisted = state.wishlistedIds.contains(product.id);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          ProductImageGallery(
            product: product,
            isWishlisted: isWishlisted,
            fabScale: _fabScale,
            onBack: () => Navigator.pop(context),
            onWishlistTap: () {
              ref.read(productProvider.notifier).toggleWishlist(product);
              _animateFab();
            },
            onImageChanged: (index) {
              ref.read(productProvider.notifier).changeSelectedImage(index);
            },
            selectedImageIndex: state.selectedImageIndex,
          ),

          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: colorScheme.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    product.title,
                    style: textTheme.headlineLarge?.copyWith(
                      fontSize: 22,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating + Stock
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.rating,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '(${product.reviews.length} reviews)',
                        style: AppTextStyles.caption.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: product.stock > 0
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.availabilityStatus,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: product.stock > 0
                                ? AppColors.success
                                : colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${product.discountedPrice.toStringAsFixed(0)}',
                        style: AppTextStyles.price.copyWith(
                          fontSize: 28,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (product.discountPercentage > 0) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: AppTextStyles.price.copyWith(
                              fontSize: 16,
                              color: colorScheme.onSurfaceVariant,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.discountBadge,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // Description
                  Text('Description', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info cards
                  InfoRow(
                    icon: Icons.local_shipping_outlined,
                    label: 'Shipping',
                    value: product.shippingInformation,
                  ),
                  const SizedBox(height: 10),
                  InfoRow(
                    icon: Icons.verified_user_outlined,
                    label: 'Warranty',
                    value: product.warrantyInformation,
                  ),
                  const SizedBox(height: 10),
                  InfoRow(
                    icon: Icons.assignment_return_outlined,
                    label: 'Returns',
                    value: product.returnPolicy,
                  ),

                  const SizedBox(height: 24),

                  // Reviews
                  if (product.reviews.isNotEmpty) ...[
                    Text('Reviews', style: textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ...product.reviews
                        .take(3)
                        .map((r) => ReviewCard(review: r)),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AddToCartBar(product: product),
    );
  }
}
