import 'package:catalog/core/themes/theme.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: AppTextStyles.title.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or filters',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
