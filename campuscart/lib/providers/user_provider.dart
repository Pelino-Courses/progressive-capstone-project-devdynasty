// ============================================================
// CampusCart - Phase 6 (Firebase Authentication)
// File: user_provider.dart
// Purpose: Real user authentication via Firebase.
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user.dart' as app_user;

class UserProvider with ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  app_user.User? _currentUser;
  bool _isLoading = false;
  String? _lastError;

  UserProvider() {
    // Listen for Firebase auth state changes (auto sign-in on app start)
    _auth.authStateChanges().listen((fb.User? firebaseUser) {
      if (firebaseUser != null) {
        _currentUser = _mapFirebaseUser(firebaseUser);
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // ===== GETTERS =====
  app_user.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get lastError => _lastError;

  String get userName => _currentUser?.fullName ?? 'Guest';
  String get userEmail => _currentUser?.email ?? '';
  String get userUniversity => _currentUser?.university ?? '';
  String get userId => _currentUser?.id ?? '';

  // ===== ACTIONS =====

  // Sign in with email + password via Firebase
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        _currentUser = _mapFirebaseUser(credential.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } on fb.FirebaseAuthException catch (e) {
      _lastError = _friendlyAuthError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _lastError = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register a new user with Firebase
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String university,
    required String password,
  }) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        // Save the user's full name in Firebase Auth profile
        await credential.user!.updateDisplayName(fullName);

        // Reload to get the updated profile
        await credential.user!.reload();
        final updatedUser = _auth.currentUser;

        _currentUser = app_user.User(
          id: updatedUser?.uid ?? credential.user!.uid,
          fullName: fullName,
          email: email.trim(),
          university: university,
        );

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } on fb.FirebaseAuthException catch (e) {
      _lastError = _friendlyAuthError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _lastError = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Update user profile
  void updateProfile({
    String? fullName,
    String? university,
    String? profilePicture,
  }) {
    if (_currentUser == null) return;
    _currentUser = app_user.User(
      id: _currentUser!.id,
      fullName: fullName ?? _currentUser!.fullName,
      email: _currentUser!.email,
      university: university ?? _currentUser!.university,
      profilePicture: profilePicture ?? _currentUser!.profilePicture,
    );
    notifyListeners();
  }

  // ===== HELPERS =====

  // Convert a Firebase user to our app's User model
  app_user.User _mapFirebaseUser(fb.User firebaseUser) {
    return app_user.User(
      id: firebaseUser.uid,
      fullName: firebaseUser.displayName ?? _extractNameFromEmail(firebaseUser.email ?? ''),
      email: firebaseUser.email ?? '',
      university: 'University of Rwanda', // default - real value comes from Firestore in Phase 7
    );
  }

  // Convert Firebase error codes to user-friendly messages
  String _friendlyAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already registered. Try signing in.';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled.';
      case 'weak-password':
        return 'Password is too weak. Use 6+ characters.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'too-many-requests':
        return 'Too many failed attempts. Try again later.';
      default:
        return e.message ?? 'Authentication failed: ${e.code}';
    }
  }

  String _extractNameFromEmail(String email) {
    if (email.isEmpty) return 'User';
    final namePart = email.split('@').first;
    return namePart
        .split(RegExp(r'[._-]'))
        .map((s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1))
        .join(' ');
  }
}