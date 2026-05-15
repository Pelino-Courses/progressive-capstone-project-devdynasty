// ============================================================
// Phase 3+5 - Local Database (with favorites support)
// File: product_database.dart
// ============================================================

import 'package:hive/hive.dart';
import '../models/product.dart';

class ProductDatabase {
  static const String _boxName = 'products';
  static const String _metaBoxName = 'meta';
  static const String _favoritesBoxName = 'favorites';

  Box<Product> get _box => Hive.box<Product>(_boxName);
  Box get _metaBox => Hive.box(_metaBoxName);
  Box<String> get _favoritesBox => Hive.box<String>(_favoritesBoxName);

  // ===== CREATE =====
  Future<void> insertProduct(Product product) async {
    await _box.put(product.id, product);
    await _box.flush();
  }

  Future<void> insertMultipleProducts(List<Product> products) async {
    final Map<String, Product> entries = {
      for (var p in products) p.id: p,
    };
    await _box.putAll(entries);
    await _box.flush();
  }

  // ===== READ =====
  List<Product> getAllProducts() => _box.values.toList();

  Product? getProductById(String id) => _box.get(id);

  List<Product> getProductsByCategory(String category) {
    return _box.values.where((p) => p.category == category).toList();
  }

  List<Product> searchProducts(String keyword) {
    final lower = keyword.toLowerCase();
    return _box.values
        .where((p) =>
            p.title.toLowerCase().contains(lower) ||
            p.description.toLowerCase().contains(lower))
        .toList();
  }

  List<Product> getProductsBySeller(String sellerId) {
    return _box.values.where((p) => p.sellerId == sellerId).toList();
  }

  // ===== UPDATE =====
  Future<void> updateProduct(Product product) async {
    await _box.put(product.id, product);
    await _box.flush();
  }

  // ===== DELETE =====
  Future<void> deleteProduct(String id) async {
    await _box.delete(id);
    await _box.flush();
    // Also remove from favorites if present
    await removeFavorite(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
    await _box.flush();
  }

  // ===== HELPERS =====
  int get count => _box.length;
  bool get isEmpty => _box.isEmpty;

  // ===== SEEDING FLAG =====
  bool get hasSeeded => _metaBox.get('hasSeeded', defaultValue: false) as bool;

  Future<void> markSeeded() async {
    await _metaBox.put('hasSeeded', true);
    await _metaBox.flush();
  }

  // ===== FAVORITES =====
  // Stored as a set of product IDs

  List<String> getFavoriteIds() => _favoritesBox.values.toList();

  bool isFavorite(String productId) =>
      _favoritesBox.values.contains(productId);

  Future<void> addFavorite(String productId) async {
    if (!isFavorite(productId)) {
      await _favoritesBox.put(productId, productId);
      await _favoritesBox.flush();
    }
  }

  Future<void> removeFavorite(String productId) async {
    if (isFavorite(productId)) {
      await _favoritesBox.delete(productId);
      await _favoritesBox.flush();
    }
  }

  Future<void> toggleFavorite(String productId) async {
    if (isFavorite(productId)) {
      await removeFavorite(productId);
    } else {
      await addFavorite(productId);
    }
  }

  // Get the actual Product objects that are favorites
  List<Product> getFavoriteProducts() {
    final favIds = getFavoriteIds();
    return _box.values.where((p) => favIds.contains(p.id)).toList();
  }
}