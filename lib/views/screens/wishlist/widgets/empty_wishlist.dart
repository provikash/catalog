import 'package:catalog/core/themes/theme.dart';
import 'package:flutter/material.dart';

class EmptyWishlist extends StatelessWidget {
  final VoidCallback onBrowse;

  const EmptyWishlist({super.key, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 72,
              color: AppColors.wishlistInactive,
            ),
            const SizedBox(height: 20),
            Text(
              'Your wishlist is empty',
              style: textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on any product to save it here',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: onBrowse,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: const Text('Browse Products', style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }
}
