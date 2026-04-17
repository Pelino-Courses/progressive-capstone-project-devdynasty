// ============================================================
// PART B - OOP & Data Models
// File: buyer.dart
// Purpose: Buyer class that EXTENDS User (inheritance example).
// ============================================================

import 'user.dart';

class Buyer extends User {
  // ADDITIONAL properties specific to Buyers
  List<String> favoriteProductIds;
  int totalPurchases;

  Buyer({
    required String id,
    required String fullName,
    required String email,
    required String university,
    String? profilePicture,
    List<String>? favoriteProductIds,
    this.totalPurchases = 0,
  })  : favoriteProductIds = favoriteProductIds ?? [],
        super(
          id: id,
          fullName: fullName,
          email: email,
          university: university,
          profilePicture: profilePicture,
        );

  // NEW METHOD - buyers save products as favorites
  void addToFavorites(String productId) {
    if (!favoriteProductIds.contains(productId)) {
      favoriteProductIds.add(productId);
      print('$fullName added product $productId to favorites');
    }
  }

  // NEW METHOD - make an offer on a product
  void makeOffer(String productTitle, int offerAmount) {
    print('$fullName made an offer of $offerAmount RWF on "$productTitle"');
  }

  // NEW METHOD - record a purchase
  void recordPurchase() {
    totalPurchases++;
    print('Purchase recorded. Total purchases for $fullName: $totalPurchases');
  }

  @override
  String getDisplayName() {
    return '$fullName ($totalPurchases purchases)';
  }

  @override
  String toString() {
    return 'Buyer(name: $fullName, purchases: $totalPurchases, favorites: ${favoriteProductIds.length})';
  }
}