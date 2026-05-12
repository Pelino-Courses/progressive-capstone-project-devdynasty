// ============================================================
// Phase 2 - State Management
// File: product_provider.dart
// Purpose: Centralized state for all products. Any screen
//          can read, update, and listen to this state.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

// 'ChangeNotifier' lets this class notify listeners when state changes
class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  // ===== PRIVATE STATE =====
  List<Product> _allProducts = [];
  List<Product> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // ===== PUBLIC GETTERS =====
  // Screens read state through these getters

  List<Product> get allProducts => _allProducts;
  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Smart getter - returns products filtered by category AND search query
  List<Product> get filteredProducts {
    List<Product> result = _allProducts;

    // Filter by category first
    if (_selectedCategory != 'All') {
      result =
          result.where((p) => p.category == _selectedCategory).toList();
    }

    // Then filter by search query
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return result;
  }

  // Returns total count of filtered products
  int get filteredCount => filteredProducts.length;

  // ===== ACTIONS =====
  // Screens call these methods to update state

  // Load all products from the service
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // tells the UI to rebuild

    try {
      _allProducts = await _productService.fetchAllProducts();
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update the selected category filter
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Update the search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear the search query
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Add a new product to the list
  Future<bool> addProduct(Product product) async {
    final success = await _productService.postProduct(product);
    if (success) {
      _allProducts.add(product);
      notifyListeners();
    }
    return success;
  }

  // Toggle favorite status
  void toggleFavorite(Product product) {
    if (_favorites.any((p) => p.id == product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.any((p) => p.id == product.id);
  }
}