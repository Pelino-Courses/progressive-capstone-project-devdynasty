// ============================================================
// PART B - OOP & Data Models
// File: product.dart
// Purpose: Product class demonstrating mixins (Rateable + Timestamped)
// ============================================================

import 'rateable.dart';
import 'timestamped.dart';

// 'with' keyword applies mixins to this class
class Product with Rateable, Timestamped {
  final String id;
  final String title;
  final String description;
  final int priceInRwf;
  final String category;
  final String condition; // 'New', 'Like New', 'Good', 'Fair', 'Used'
  final String sellerId;
  final String sellerName;
  final String location;
  String? imageUrl;
  bool isAvailable;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.priceInRwf,
    required this.category,
    required this.condition,
    required this.sellerId,
    required this.sellerName,
    required this.location,
    this.imageUrl,
    this.isAvailable = true,
  });

  // Mark as sold - uses markUpdated from Timestamped mixin
  void markAsSold() {
    isAvailable = false;
    markUpdated(); // from Timestamped mixin
    print('$title has been marked as SOLD');
  }

  // Reduce price (seller discount)
  Product copyWithNewPrice(int newPrice) {
    return Product(
      id: id,
      title: title,
      description: description,
      priceInRwf: newPrice,
      category: category,
      condition: condition,
      sellerId: sellerId,
      sellerName: sellerName,
      location: location,
      imageUrl: imageUrl,
      isAvailable: isAvailable,
    );
  }

  // A complete summary using features from BOTH mixins
  String fullSummary() {
    return '''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 $title
💰 $priceInRwf RWF · $condition
📍 $location
👤 Seller: $sellerName
$starDisplay ($averageRating / 5 - $ratingCount ratings)
$postedTimeAgo
Status: ${isAvailable ? '✅ Available' : '❌ Sold'}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''';
  }

  @override
  String toString() {
    return 'Product($title, $priceInRwf RWF, $condition)';
  }
}