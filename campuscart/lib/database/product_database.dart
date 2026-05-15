// ============================================================
// Phase 3 - Local Database (with explicit flush)
// File: product_database.dart
// Purpose: Hive-based database with forced disk writes.
// ============================================================

import 'package:hive/hive.dart';
import '../models/product.dart';

class ProductDatabase {
  static const String _boxName = 'products';
  static const String _metaBoxName = 'meta';

  Box<Product> get _box => Hive.box<Product>(_boxName);
  Box get _metaBox => Hive.box(_metaBoxName);

  // ===== CREATE =====
  Future<void> insertProduct(Product product) async {
    await _box.put(product.id, product);
    await _box.flush(); // 🔥 force write to disk immediately
  }

  Future<void> insertMultipleProducts(List<Product> products) async {
    final Map<String, Product> entries = {
      for (var p in products) p.id: p,
    };
    await _box.putAll(entries);
    await _box.flush();
  }

  // ===== READ =====
  List<Product> getAllProducts() {
    return _box.values.toList();
  }

  Product? getProductById(String id) {
    return _box.get(id);
  }

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
  }

  Future<void> clearAll() async {
    await _box.clear();
    await _box.flush();
  }

  // ===== HELPERS =====
  int get count => _box.length;
  bool get isEmpty => _box.isEmpty;

  // ===== SEEDING FLAG =====
  // Track whether we've ever seeded demo data, so we don't reseed
  // and accidentally overwrite or duplicate.
  bool get hasSeeded => _metaBox.get('hasSeeded', defaultValue: false) as bool;

  Future<void> markSeeded() async {
    await _metaBox.put('hasSeeded', true);
    await _metaBox.flush();
  }
}