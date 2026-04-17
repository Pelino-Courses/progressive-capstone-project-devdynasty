// ============================================================
// PART B - OOP & Data Models
// File: rateable.dart
// Purpose: Rateable MIXIN - adds rating functionality to any class
//          that mixes it in (Product, Seller, etc.)
// ============================================================

// 'mixin' keyword creates a reusable bundle of features
mixin Rateable {
  // Properties that any class mixing this in will get
  List<double> ratings = [];

  // Add a new rating (must be between 0 and 5)
  void addRating(double rating) {
    if (rating < 0 || rating > 5) {
      print('Invalid rating: $rating. Must be between 0 and 5.');
      return;
    }
    ratings.add(rating);
  }

  // Calculate the average rating
  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    double sum = ratings.reduce((a, b) => a + b);
    return sum / ratings.length;
  }

  // Total number of ratings
  int get ratingCount => ratings.length;

  // Star display for UI (e.g. "⭐⭐⭐⭐")
  String get starDisplay {
    int fullStars = averageRating.round();
    return '⭐' * fullStars;
  }

  // Is this item rated well? (4+ stars)
  bool get isHighlyRated => averageRating >= 4.0;
}