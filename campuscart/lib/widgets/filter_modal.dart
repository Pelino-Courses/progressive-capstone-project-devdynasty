// ============================================================
// Phase 5 - Filter Modal
// File: filter_modal.dart
// Purpose: Bottom-sheet modal with price range, condition, sort.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String? _selectedCondition;
  ProductSort _selectedSort = ProductSort.newest;

  final List<String> _conditions = [
    'New',
    'Like New',
    'Good',
    'Fair',
    'Used',
  ];

  final Map<ProductSort, String> _sortLabels = {
    ProductSort.newest: 'Newest first',
    ProductSort.priceLowToHigh: 'Price: Low to High',
    ProductSort.priceHighToLow: 'Price: High to Low',
    ProductSort.titleAZ: 'Title: A-Z',
  };

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing filter values
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (provider.minPrice != null) {
      _minPriceController.text = provider.minPrice.toString();
    }
    if (provider.maxPrice != null) {
      _maxPriceController.text = provider.maxPrice.toString();
    }
    _selectedCondition = provider.conditionFilter;
    _selectedSort = provider.sortBy;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    final minPrice = int.tryParse(_minPriceController.text.trim());
    final maxPrice = int.tryParse(_maxPriceController.text.trim());

    provider.setPriceRange(min: minPrice, max: maxPrice);
    provider.setConditionFilter(_selectedCondition);
    provider.setSortBy(_selectedSort);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filters applied'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _resetFilters() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.resetFilters();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filters cleared'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Filters & Sort',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // ===== PRICE RANGE =====
            const Text(
              'Price Range (RWF)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Min',
                      prefixText: 'RWF ',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('-'),
                ),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Max',
                      prefixText: 'RWF ',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===== CONDITION =====
            const Text(
              'Condition',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _conditionChip('Any', null),
                ..._conditions.map((cond) => _conditionChip(cond, cond)),
              ],
            ),

            const SizedBox(height: 20),

            // ===== SORT BY =====
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            ..._sortLabels.entries.map((entry) {
              return RadioListTile<ProductSort>(
                contentPadding: EdgeInsets.zero,
                value: entry.key,
                groupValue: _selectedSort,
                onChanged: (value) =>
                    setState(() => _selectedSort = value!),
                title: Text(entry.value),
                activeColor: AppTheme.primaryColor,
                dense: true,
              );
            }),

            const SizedBox(height: 16),

            // ===== ACTION BUTTONS =====
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _conditionChip(String label, String? value) {
    final isSelected = _selectedCondition == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedCondition = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}