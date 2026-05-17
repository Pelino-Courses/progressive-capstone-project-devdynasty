// ============================================================
// PART B - OOP & Data Models
// File: seller.dart
// Purpose: Seller class that EXTENDS User (inheritance example).
// ============================================================

import 'user.dart';

// 'extends User' means Seller inherits all User's properties and methods
class Seller extends User {
  // ADDITIONAL properties specific to Sellers
  int totalSales;
  double averageRating;
  bool isVerified;

  // CONSTRUCTOR - must call super() to initialize inherited properties
  Seller({
    required String id,
    required String fullName,
    required String email,
    required String university,
    String? profilePicture,
    this.totalSales = 0,
    this.averageRating = 0.0,
    this.isVerified = false,
  }) : super(
          id: id,
          fullName: fullName,
          email: email,
          university: university,
          profilePicture: profilePicture,
        );

  // NEW METHOD - only sellers can post listings
  void postListing(String productTitle) {
    print('$fullName posted a new listing: "$productTitle"');
  }

  // NEW METHOD - update sales count
  void recordSale() {
    totalSales++;
    print('Sale recorded. Total sales for $fullName: $totalSales');
  }

  // OVERRIDE - replace User's getDisplayName with a seller-specific version
  @override
  String getDisplayName() {
    String verifiedBadge = isVerified ? ' ✓' : '';
    return '$fullName$verifiedBadge (⭐ $averageRating - $totalSales sales)';
  }

  @override
  String toString() {
    return 'Seller(name: $fullName, sales: $totalSales, rating: $averageRating)';
  }
}