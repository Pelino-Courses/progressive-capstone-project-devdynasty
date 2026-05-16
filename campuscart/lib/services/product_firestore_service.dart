// ============================================================
// Phase 7 - Firestore Service
// File: product_firestore_service.dart
// Purpose: Wrapper around Cloud Firestore for product CRUD.
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductFirestoreService {
  // Reference to the 'products' collection in Firestore
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  // ===== CREATE =====
  Future<void> addProduct(Product product) async {
    await _productsRef.doc(product.id).set(_toFirestoreMap(product));
  }

  // ===== READ =====
  // One-time fetch of all products
  Future<List<Product>> fetchAllProducts() async {
    final snapshot = await _productsRef.get();
    return snapshot.docs
        .map((doc) => _fromFirestoreMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Real-time stream of all products (auto-updates when data changes)
  Stream<List<Product>> streamAllProducts() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              _fromFirestoreMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get one product by ID
  Future<Product?> fetchProductById(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestoreMap(doc.data() as Map<String, dynamic>);
  }

  // Get all products posted by a specific seller
  Future<List<Product>> fetchProductsBySeller(String sellerId) async {
    final snapshot =
        await _productsRef.where('sellerId', isEqualTo: sellerId).get();
    return snapshot.docs
        .map((doc) => _fromFirestoreMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // ===== UPDATE =====
  Future<void> updateProduct(Product product) async {
    await _productsRef.doc(product.id).update(_toFirestoreMap(product));
  }

  // ===== DELETE =====
  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  // ===== SERIALIZATION =====
  // Convert a Product to a Firestore-friendly Map
  Map<String, dynamic> _toFirestoreMap(Product product) {
    return {
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'priceInRwf': product.priceInRwf,
      'category': product.category,
      'condition': product.condition,
      'sellerId': product.sellerId,
      'sellerName': product.sellerName,
      'location': product.location,
      'imageUrl': product.imageUrl,
      'imageBytes': product.imageBytes, // stored as List<int>
      'isAvailable': product.isAvailable,
      'createdAt': product.createdAt.toIso8601String(),
    };
  }

  // Convert a Firestore Map back to a Product
  Product _fromFirestoreMap(Map<String, dynamic> map) {
    final product = Product(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priceInRwf: map['priceInRwf'] as int,
      category: map['category'] as String,
      condition: map['condition'] as String,
      sellerId: map['sellerId'] as String,
      sellerName: map['sellerName'] as String,
      location: map['location'] as String,
      imageUrl: map['imageUrl'] as String?,
      isAvailable: map['isAvailable'] as bool? ?? true,
      imageBytes: (map['imageBytes'] as List?)?.cast<int>(),
    );
    return product;
  }
}