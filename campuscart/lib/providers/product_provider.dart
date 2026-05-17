// ============================================================
// CampusCart - Phase 7 (Firestore), updated in Phase 8
// File: product_provider.dart
// Purpose: Products sync via Cloud Firestore in real-time.
//          Phase 8: product images are uploaded to Firebase
//          Storage; only the image URL is kept in Firestore.
//          Favorites still use local Hive.
// ============================================================

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../database/product_database.dart';
import '../services/product_firestore_service.dart';
import '../services/storage_service.dart';

enum ProductSort {
  newest,
  priceLowToHigh,
  priceHighToLow,
  titleAZ,
}

class ProductProvider with ChangeNotifier {
  final ProductDatabase _localDb = ProductDatabase(); // for favorites only
  final ProductFirestoreService _firestore = ProductFirestoreService();
  final StorageService _storage = StorageService(); // Phase 8: image uploads

  StreamSubscription<List<Product>>? _productsSubscription;

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

  bool get hasActiveFilters =>
      _minPrice != null ||
      _maxPrice != null ||
      _conditionFilter != null ||
      _sortBy != ProductSort.newest;

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

    if (_minPrice != null) {
      result = result.where((p) => p.priceInRwf >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      result = result.where((p) => p.priceInRwf <= _maxPrice!).toList();
    }

    if (_conditionFilter != null) {
      result =
          result.where((p) => p.condition == _conditionFilter).toList();
    }

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

  List<Product> get favoriteProducts {
    final favIds = _localDb.getFavoriteIds();
    return _allProducts.where((p) => favIds.contains(p.id)).toList();
  }

  int get favoritesCount => _localDb.getFavoriteIds().length;

  // ===== LOAD with real-time stream =====
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if Firestore is empty; if yes, seed initial data once
      final existing = await _firestore.fetchAllProducts();
      if (existing.isEmpty) {
        await _seedInitialData();
      }

      // Subscribe to real-time updates from Firestore
      _productsSubscription?.cancel();
      _productsSubscription = _firestore.streamAllProducts().listen(
        (products) {
          _allProducts = products;
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = 'Failed to sync products: $error';
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
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

    for (final p in demoProducts) {
      await _firestore.addProduct(p);
    }
  }

  // ===== CRUD via Firestore =====
  Future<bool> addProduct(Product product) async {
    try {
      await _firestore.addProduct(product);
      // No need to manually update _allProducts - the stream will handle it!
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      notifyListeners();
      return false;
    }
  }

  // Phase 8: add a product WITH a photo.
  // Flow: upload the image to Firebase Storage -> get a URL ->
  // save the product (carrying that URL) to Firestore.
  // If [imageBytes] is null, this behaves like a normal add.
  Future<bool> addProductWithImage({
    required Product product,
    Uint8List? imageBytes,
  }) async {
    try {
      Product productToSave = product;

      if (imageBytes != null && imageBytes.isNotEmpty) {
        // 1. Upload the photo to Firebase Storage.
        final downloadUrl = await _storage.uploadProductImage(
          productId: product.id,
          imageBytes: imageBytes,
        );
        // 2. Attach the URL to the product before saving.
        productToSave.imageUrl = downloadUrl;
      }

      // 3. Save to Firestore (the real-time stream updates the UI).
      await _firestore.addProduct(productToSave);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await _firestore.updateProduct(product);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _firestore.deleteProduct(productId);
      await _localDb.removeFavorite(productId);
      // Phase 8: also remove the product's image from Storage
      // so we don't leave orphaned files in the bucket.
      await _storage.deleteProductImage(productId);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<List<Product>> getProductsBySeller(String sellerId) async {
    return await _firestore.fetchProductsBySeller(sellerId);
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

  // ===== FAVORITES (local) =====
  bool isFavorite(Product product) => _localDb.isFavorite(product.id);

  Future<void> toggleFavorite(Product product) async {
    await _localDb.toggleFavorite(product.id);
    notifyListeners();
  }

  // ===== CLEANUP =====
  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}