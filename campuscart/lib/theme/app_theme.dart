// ============================================================
// PART C - Flutter Widgets & UI
// File: app_theme.dart
// Purpose: Centralized Material Design 3 theme for the whole app.
// ============================================================

import 'package:flutter/material.dart';

class AppTheme {
  // Primary color of the app - a deep trustworthy blue/teal
  static const Color primaryColor = Color(0xFF0F766E);   // teal-700
  static const Color accentColor = Color(0xFF14B8A6);    // teal-500
  static const Color backgroundColor = Color(0xFFF9FAFB); // very light grey
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFDC2626);      // red-600
  static const Color successColor = Color(0xFF16A34A);    // green-600
  static const Color textPrimary = Color(0xFF111827);     // near-black
  static const Color textSecondary = Color(0xFF6B7280);   // grey

  // The complete light theme for the app
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // enable Material Design 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,

    // AppBar style used across all screens
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Elevated button style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Input field style (for forms)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
    ),

    // Card style (used for product cards)
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}