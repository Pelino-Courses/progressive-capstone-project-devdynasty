// ============================================================
// PART B - OOP & Data Models
// File: user.dart
// Purpose: Base User class that Seller and Buyer will extend.
// ============================================================

class User {
  // PROPERTIES (fields)
  final String id;
  final String fullName;
  final String email;
  final String university;
  String? profilePicture; // nullable - user may not have one

  // CONSTRUCTOR - how we create a User object
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.university,
    this.profilePicture,
  });

  // METHOD - a function that belongs to this class
  String getDisplayName() {
    return '$fullName ($university)';
  }

  // Check if the user has completed their profile
  bool isProfileComplete() {
    return profilePicture != null;
  }

  // Override toString so printing a User is readable
  @override
  String toString() {
    return 'User(id: $id, name: $fullName, email: $email)';
  }
}