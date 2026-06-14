import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalog/core/themes/theme.dart';
import 'package:catalog/models/product_models.dart';
import 'package:flutter/material.dart';

class ProductImageGallery extends StatelessWidget {
  final ProductModels product;
  final int selectedImageIndex;
  final bool isWishlisted;
  final Animation<double> fabScale;

  final VoidCallback onBack;
  final VoidCallback onWishlistTap;
  final ValueChanged<int> onImageChanged;

  const ProductImageGallery({
    super.key,
    required this.product,
    required this.selectedImageIndex,
    required this.isWishlisted,
    required this.fabScale,
    required this.onBack,
    required this.onWishlistTap,
    required this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    
      
    return SliverAppBar(
          expandedHeight: 340,
          pinned: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: onBack,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: AppColors.cardShadow, blurRadius: 8),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          actions: [
            ScaleTransition(
              scale: fabScale,
              child: GestureDetector(
                onTap:
                  onWishlistTap
                ,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: AppColors.cardShadow, blurRadius: 8),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      isWishlisted
                          ? Icons.favorite
                          : Icons.favorite_border_rounded,
                      key: ValueKey(isWishlisted),
                      size: 20,
                      color: isWishlisted
                          ? AppColors.wishlistActive
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                // Main image
                Hero(
                  tag: 'product-image-${product.id}',
                  child: CachedNetworkImage(
                    imageUrl: product.images.isNotEmpty
                        ? product.images[selectedImageIndex]
                        : product.thumbnail,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, progress) => Container(
                      color: AppColors.imageBorder,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: AppColors.wishlistInactive,
                      ),
                    ),
                  ),
                ),
                // Gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
                // Image thumbnails
                if (product.images.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.images.length,
                        (i) => GestureDetector(
                          onTap: () {
                            onImageChanged (i);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: selectedImageIndex == i ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: selectedImageIndex == i
                                  ? colorScheme.primary
                                  : colorScheme.outline,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        
    );
  }
}