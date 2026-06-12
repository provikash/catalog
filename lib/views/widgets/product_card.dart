import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/product_models.dart';

class ProductCard extends StatefulWidget {
  final ProductModels? product;
  final bool isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    this.product,
    this.isLoading = false,
    this.onTap,
    this.onWishlistTap,
    this.isWishlisted = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: widget.isLoading,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) =>
              Transform.scale(scale: _scaleAnimation.value, child: child),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: widget.isLoading
                            ? Container(color: Colors.grey.shade200)
                            : CachedNetworkImage(
                                imageUrl: widget.product?.thumbnail ?? '',
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                              ),
                      ),
                    ),
                    
                    if (!widget.isLoading &&
                        (widget.product?.discountPercentage ?? 0) > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${widget.product!.discountPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    // Wishlist button
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: widget.onWishlistTap,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: widget.isWishlisted
                                ? Colors.redAccent
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Info Section
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isLoading
                            ? 'Product Title Here'
                            : (widget.product?.title ?? ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 13, color: Color(0xFFFFC107)),
                          const SizedBox(width: 2),
                          Text(
                            widget.isLoading
                                ? '4.5'
                                : (widget.product?.rating
                                        .toStringAsFixed(1) ??
                                    ''),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.isLoading
                                ? '₹999'
                                : '₹${widget.product?.discountedPrice.toStringAsFixed(0) ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (!widget.isLoading &&
                              (widget.product?.discountPercentage ?? 0) > 0)
                            Text(
                              '₹${widget.product?.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
