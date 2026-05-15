// ============================================================
// CampusCart - Phase 3 (clean version)
// File: product_provider.dart
// Purpose: Centralized state for products, backed by Hive.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../database/product_database.dart';

class ProductProvider with ChangeNotifier {
  final ProductDatabase _db = ProductDatabase();

  List<Product> _allProducts = [];
  List<Product> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // ===== GETTERS =====
  List<Product> get allProducts => _allProducts;
  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Product> get filteredProducts {
    List<Product> result = _allProducts;
    if (_selectedCategory != 'All') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
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

  int get filteredCount => filteredProducts.length;

  // ===== LOAD =====
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!_db.hasSeeded) {
        await _seedInitialData();
        await _db.markSeeded();
      }
      _allProducts = _db.getAllProducts();
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _seedInitialData() async {
    final demoProducts = [
      Product(
        id: 'P001',
        title: 'Calculus Textbook',
        description:
            'Used for one semester, excellent condition. All pages intact.',
        priceInRwf: 5000,
        category: 'Books',
        condition: 'Like New',
        sellerId: 'S001',
        sellerName: 'John Kalisa',
        location: 'Hostel B',
      ),
      Product(
        id: 'P002',
        title: 'Nike Running Shoes',
        description: 'Size 42, worn twice. Still fresh.',
        priceInRwf: 25000,
        category: 'Clothing',
        condition: 'Like New',
        sellerId: 'S002',
        sellerName: 'Alice Mukamana',
        location: 'Hostel A',
      ),
      Product(
        id: 'P003',
        title: 'Laptop Charger - HP',
        description: 'Original HP charger, 65W. Fully working.',
        priceInRwf: 8000,
        category: 'Electronics',
        condition: 'Good',
        sellerId: 'S001',
        sellerName: 'John Kalisa',
        location: 'Campus Main',
      ),
      Product(
        id: 'P004',
        title: 'Study Desk',
        description: 'Wooden desk, 120cm x 60cm. Good for dorm rooms.',
        priceInRwf: 35000,
        category: 'Furniture',
        condition: 'Good',
        sellerId: 'S003',
        sellerName: 'Bob Nshimiye',
        location: 'Hostel C',
      ),
    ];

    await _db.insertMultipleProducts(demoProducts);
  }

  // ===== CRUD =====
  Future<bool> addProduct(Product product) async {
    try {
      await _db.insertProduct(product);
      _allProducts = _db.getAllProducts();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await _db.updateProduct(product);
      _allProducts = _db.getAllProducts();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _db.deleteProduct(productId);
      _allProducts = _db.getAllProducts();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: $e';
      notifyListeners();
      return false;
    }
  }

  List<Product> getProductsBySeller(String sellerId) {
    return _db.getProductsBySeller(sellerId);
  }

  Future<void> resetDatabase() async {
    await _db.clearAll();
    _allProducts = [];
    notifyListeners();
  }

  // ===== FILTERS =====
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // ===== FAVORITES =====
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