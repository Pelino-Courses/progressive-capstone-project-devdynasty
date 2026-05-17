// ============================================================
// CampusCart - Refactored in Phase 4, Phase 8
// File: product.dart
// Purpose: Product class with image support.
//
// Phase 8 note on images:
//   - imageUrl  -> a Firebase Storage download URL. This is now
//                  the PRIMARY way images are stored & shown.
//   - imageBytes-> kept only for backward compatibility (older
//                  Phase 4-7 products / local picks before
//                  upload). New products do NOT store bytes in
//                  the cloud anymore.
// ============================================================

import 'package:hive/hive.dart';
import 'rateable.dart';
import 'timestamped.dart';

part 'product.g.dart';

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

  // 🆕 NEW FIELD - stores the actual image bytes (works on web & mobile)
  @HiveField(11)
  List<int>? imageBytes;

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
    this.imageBytes,
  });

  // Returns true if the product has local image bytes
  // (used during picking, before upload, and for old data).
  bool get hasImage => imageBytes != null && imageBytes!.isNotEmpty;

  // Phase 8: returns true if the product has a Firebase Storage
  // image URL. This is the preferred image source for display.
  bool get hasNetworkImage => imageUrl != null && imageUrl!.isNotEmpty;

  void markAsSold() {
    isAvailable = false;
    markUpdated();
  }

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
      imageBytes: imageBytes,
    );
  }

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