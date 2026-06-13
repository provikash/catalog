import 'package:catalog/core/themes/theme.dart';
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
    with TickerProviderStateMixin {
  // ✅ changed from SingleTicker

  // ── Tap scale ──
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;

  // ── Heart bounce ──
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  // ── Floating heart ──
  late AnimationController _floatController;
  late Animation<double> _floatOpacity;
  late Animation<Offset> _floatOffset;

  bool _showFloatingHeart = false;

  @override
  void initState() {
    super.initState();

    // Tap scale
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _tapController, curve: Curves.easeInOut));

    // Heart bounce: scale up → overshoot → settle
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _heartScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.85), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.0), weight: 30),
        ]).animate(
          CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
        );

    // Floating heart: appear → hold → fade while rising
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _floatOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_floatController);
    _floatOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2.5),
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _tapController.dispose();
    _heartController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _tapController.forward();
  void _onTapUp(_) {
    _tapController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _tapController.reverse();

  void _onWishlistTap() {
    // Trigger bounce
    _heartController.forward(from: 0);

    // Trigger floating heart
    setState(() => _showFloatingHeart = true);
    _floatController.forward(from: 0).then((_) {
      if (mounted) setState(() => _showFloatingHeart = false);
    });

    widget.onWishlistTap?.call();
  }

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
                // ── Image Section ──────────────
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: widget.isLoading
                              ? Container(color: Colors.grey.shade200)
                              : Hero(
                                  tag: 'product-image-${widget.product?.id}',
                                  child: CachedNetworkImage(
                                    imageUrl: widget.product?.thumbnail ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      color: Colors.grey.shade400,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      color: Colors.grey.shade100,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // Discount badge
                    if (!widget.isLoading &&
                        (widget.product?.discountPercentage ?? 0) > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${widget.product!.discountPercentage.toStringAsFixed(0)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                    // ── Wishlist button with bounce ──
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: _onWishlistTap,
                        child: AnimatedBuilder(
                          animation: _heartScale,
                          builder: (_, child) => Transform.scale(
                            scale: _heartScale.value,
                            child: child,
                          ),
                          child: Container(
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
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                widget.isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey(widget.isWishlisted),
                                size: 18,
                                color: widget.isWishlisted
                                    ? AppColors.accent
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Floating heart ──
                    if (_showFloatingHeart)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: SlideTransition(
                          position: _floatOffset,
                          child: FadeTransition(
                            opacity: _floatOpacity,
                            child: const Icon(
                              Icons.favorite,
                              color: AppColors.accent,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // ── Info Section ───────────────
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
                        style: AppTextStyles.subtitle.copyWith(
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.isLoading
                                ? '4.5'
                                : (widget.product?.rating.toStringAsFixed(1) ??
                                      ''),
                            style: AppTextStyles.caption,
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
                            style: AppTextStyles.price.copyWith(
                              fontSize: 14,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (!widget.isLoading &&
                              (widget.product?.discountPercentage ?? 0) > 0)
                            Text(
                              '₹${widget.product?.price.toStringAsFixed(0)}',
                              style: AppTextStyles.caption.copyWith(
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
