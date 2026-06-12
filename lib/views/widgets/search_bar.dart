import 'dart:async';
import 'package:flutter/material.dart';

class ProductSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback? onFilterTap;
  final String hintText;

  const ProductSearchBar({
    super.key,
    required this.onSearch,
    this.onFilterTap,
    this.hintText = 'Search products...',
  });

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      widget.onSearch(value.trim());
    });
  }

  void _clear() {
    _controller.clear();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hasText
                    ? colorScheme.primary.withOpacity(0.5)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: _hasText ? colorScheme.primary : Colors.grey.shade500,
                  size: 22,
                ),
                suffixIcon: _hasText
                    ? GestureDetector(
                        onTap: _clear,
                        child: Icon(
                          Icons.cancel_rounded,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 4,
                ),
              ),
            ),
          ),
        ),

        // Filter button
        const SizedBox(width: 10),
        GestureDetector(
          onTap: widget.onFilterTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
