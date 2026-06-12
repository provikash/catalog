import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> categories;
  final String? selectedCategory;
  final RangeValues priceRange;
  final double maxPrice;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<RangeValues> onPriceRangeChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.priceRange,
    required this.maxPrice,
    required this.onCategoryChanged,
    required this.onPriceRangeChanged,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _selectedCategory;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _priceRange = widget.priceRange;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 0,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                    _priceRange = RangeValues(0, widget.maxPrice);
                  });
                  widget.onReset();
                },
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Category Section
          const Text(
            'Category',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = widget.categories[index];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = isSelected ? null : cat;
                    });
                    widget.onCategoryChanged(isSelected ? null : cat);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      _capitalize(cat),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Price Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                '₹${_priceRange.start.toStringAsFixed(0)} – ₹${_priceRange.end.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.surfaceVariant,
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withOpacity(0.15),
              trackHeight: 4,
            ),
            child: RangeSlider(
              values: _priceRange,
              min: 0,
              max: widget.maxPrice,
              divisions: 50,
              onChanged: (range) {
                setState(() => _priceRange = range);
                widget.onPriceRangeChanged(range);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹0',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade500)),
              Text('₹${widget.maxPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),

          const SizedBox(height: 28),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
