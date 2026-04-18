// ============================================================
// PART D - Navigation & Forms
// File: add_listing_screen.dart
// Purpose: Form screen to add a new product listing with
//          full validation.
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  // GlobalKey to manage the form state (required for validation)
  final _formKey = GlobalKey<FormState>();

  // Text controllers for each input field
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  // Dropdown values
  String? _selectedCategory;
  String? _selectedCondition;

  bool _isSubmitting = false;

  final List<String> _categories = [
    'Books',
    'Clothing',
    'Electronics',
    'Furniture',
    'Others',
  ];

  final List<String> _conditions = [
    'New',
    'Like New',
    'Good',
    'Fair',
    'Used',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ---- VALIDATORS ----

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product title is required';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.trim().length > 60) {
      return 'Title must be under 60 characters';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final price = int.tryParse(value.trim());
    if (price == null) {
      return 'Price must be a valid number';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    if (price > 10000000) {
      return 'Price seems too high';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? _validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please select a $fieldName';
    }
    return null;
  }

  // ---- SUBMIT HANDLER ----

  Future<void> _submitForm() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate the form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Build a Product object from the form data
    final newProduct = Product(
      id: 'P${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priceInRwf: int.parse(_priceController.text.trim()),
      category: _selectedCategory!,
      condition: _selectedCondition!,
      sellerId: 'S001',
      sellerName: 'You', // in a real app, this comes from logged-in user
      location: _locationController.text.trim(),
    );

    // Submit via ProductService (async)
    final success = await ProductService().postProduct(newProduct);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Listing posted successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      // Return true to the previous screen (HomeScreen) to trigger refresh
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to post listing. Try again.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Listing'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Photo upload placeholder ---
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade400,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      size: 40, color: Colors.grey.shade600),
                  const SizedBox(height: 8),
                  Text(
                    'Add Photos (feature coming soon)',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Title field ---
            _buildFieldLabel('Product Title *'),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Calculus Textbook',
              ),
              validator: _validateTitle,
              maxLength: 60,
            ),
            const SizedBox(height: 12),

            // --- Category dropdown ---
            _buildFieldLabel('Category *'),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                hintText: 'Select a category',
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
              validator: (v) => _validateDropdown(v, 'category'),
            ),
            const SizedBox(height: 12),

            // --- Price field ---
            _buildFieldLabel('Price (RWF) *'),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 5000',
                prefixText: 'RWF ',
              ),
              validator: _validatePrice,
            ),
            const SizedBox(height: 12),

            // --- Condition dropdown ---
            _buildFieldLabel('Condition *'),
            DropdownButtonFormField<String>(
              initialValue: _selectedCondition,
              decoration: const InputDecoration(
                hintText: 'Select a condition',
              ),
              items: _conditions.map((cond) {
                return DropdownMenuItem(value: cond, child: Text(cond));
              }).toList(),
              onChanged: (value) =>
                  setState(() => _selectedCondition = value),
              validator: (v) => _validateDropdown(v, 'condition'),
            ),
            const SizedBox(height: 12),

            // --- Description field ---
            _buildFieldLabel('Description *'),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe your product...',
              ),
              validator: _validateDescription,
            ),
            const SizedBox(height: 12),

            // --- Location field ---
            _buildFieldLabel('Location *'),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'e.g. Hostel B',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: _validateLocation,
            ),
            const SizedBox(height: 24),

            // --- Submit button ---
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Post Listing',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widget for consistent field labels
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}