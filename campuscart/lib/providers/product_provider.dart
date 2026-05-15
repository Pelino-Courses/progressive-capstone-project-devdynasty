// ============================================================
// CampusCart - Phase 5 (persistent favorites + filters)
// File: product_provider.dart
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../database/product_database.dart';

// Sort options for advanced filtering
enum ProductSort {
  newest,
  priceLowToHigh,
  priceHighToLow,
  titleAZ,
}

class ProductProvider with ChangeNotifier {
  final ProductDatabase _db = ProductDatabase();

  List<Product> _allProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filter state
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int? _minPrice;
  int? _maxPrice;
  String? _conditionFilter;
  ProductSort _sortBy = ProductSort.newest;

  // ===== GETTERS =====
  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int? get minPrice => _minPrice;
  int? get maxPrice => _maxPrice;
  String? get conditionFilter => _conditionFilter;
  ProductSort get sortBy => _sortBy;

  // True if any non-default filter is active
  bool get hasActiveFilters =>
      _minPrice != null ||
      _maxPrice != null ||
      _conditionFilter != null ||
      _sortBy != ProductSort.newest;

  List<Product> get filteredProducts {
    List<Product> result = _allProducts;

    // Category filter
    if (_selectedCategory != 'All') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Price range filter
    if (_minPrice != null) {
      result = result.where((p) => p.priceInRwf >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      result = result.where((p) => p.priceInRwf <= _maxPrice!).toList();
    }

    // Condition filter
    if (_conditionFilter != null) {
      result =
          result.where((p) => p.condition == _conditionFilter).toList();
    }

    // Sorting
    switch (_sortBy) {
      case ProductSort.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case ProductSort.priceLowToHigh:
        result.sort((a, b) => a.priceInRwf.compareTo(b.priceInRwf));
        break;
      case ProductSort.priceHighToLow:
        result.sort((a, b) => b.priceInRwf.compareTo(a.priceInRwf));
        break;
      case ProductSort.titleAZ:
        result.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }

    return result;
  }

  int get filteredCount => filteredProducts.length;

  List<Product> get favoriteProducts => _db.getFavoriteProducts();
  int get favoritesCount => _db.getFavoriteIds().length;

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

  void setPriceRange({int? min, int? max}) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setConditionFilter(String? condition) {
    _conditionFilter = condition;
    notifyListeners();
  }

  void setSortBy(ProductSort sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void resetFilters() {
    _minPrice = null;
    _maxPrice = null;
    _conditionFilter = null;
    _sortBy = ProductSort.newest;
    notifyListeners();
  }

  // ===== FAVORITES =====
  bool isFavorite(Product product) => _db.isFavorite(product.id);

  Future<void> toggleFavorite(Product product) async {
    await _db.toggleFavorite(product.id);
    notifyListeners();
  }
}