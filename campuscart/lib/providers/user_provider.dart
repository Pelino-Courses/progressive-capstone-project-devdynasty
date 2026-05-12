// ============================================================
// Phase 2 - State Management
// File: user_provider.dart
// Purpose: Holds the currently logged-in user. Other screens
//          read from this instead of using hardcoded data.
//          Will be wired to Firebase Auth in Phase 6.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  // ===== PRIVATE STATE =====
  User? _currentUser;
  bool _isLoading = false;

  // ===== PUBLIC GETTERS =====
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Convenient getters for common user fields (returns sensible defaults)
  String get userName => _currentUser?.fullName ?? 'Guest';
  String get userEmail => _currentUser?.email ?? '';
  String get userUniversity => _currentUser?.university ?? '';
  String get userId => _currentUser?.id ?? '';

  // ===== ACTIONS =====

  // Simulate signing in (will be replaced with Firebase Auth in Phase 6)
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // For now, accept any valid email + password >= 6 chars
    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = User(
        id: 'U_${DateTime.now().millisecondsSinceEpoch}',
        fullName: _extractNameFromEmail(email),
        email: email,
        university: 'University of Rwanda',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Simulate registering a new user
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String university,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: 'U_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      university: university,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  // Update user profile (e.g. from edit profile screen)
  void updateProfile({
    String? fullName,
    String? university,
    String? profilePicture,
  }) {
    if (_currentUser == null) return;

    _currentUser = User(
      id: _currentUser!.id,
      fullName: fullName ?? _currentUser!.fullName,
      email: _currentUser!.email,
      university: university ?? _currentUser!.university,
      profilePicture: profilePicture ?? _currentUser!.profilePicture,
    );
    notifyListeners();
  }

  // Helper - extract a display name from an email
  String _extractNameFromEmail(String email) {
    final namePart = email.split('@').first;
    return namePart
        .split(RegExp(r'[._-]'))
        .map((s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1))
        .join(' ');
  }
}