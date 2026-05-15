// ============================================================
// CampusCart - Refactored in Phase 3
// File: product.dart
// Purpose: Product class with Hive annotations for persistence.
// ============================================================

import 'package:hive/hive.dart';
import 'rateable.dart';
import 'timestamped.dart';

// This 'part' tells Dart that auto-generated code lives in product.g.dart
// We'll generate that file in the next step.
part 'product.g.dart';

// 'typeId' is a unique number that identifies this class in Hive storage.
// Every Hive-stored class needs a unique typeId (0-223 range).
@HiveType(typeId: 0)
class Product extends HiveObject with Rateable, Timestamped {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int priceInRwf;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String condition;

  @HiveField(6)
  final String sellerId;

  @HiveField(7)
  final String sellerName;

  @HiveField(8)
  final String location;

  @HiveField(9)
  String? imageUrl;

  @HiveField(10)
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

  // Mark as sold
  void markAsSold() {
    isAvailable = false;
    markUpdated(); // from Timestamped mixin
  }

  // Helper to create a modified copy
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

  // Full summary using mixin features
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