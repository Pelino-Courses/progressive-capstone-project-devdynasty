// ============================================================
// CampusCart - Entry Point
// Team: DevDynasty
// ============================================================

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/add_listing_screen.dart';

void main() {
  runApp(const CampusCartApp());
}

class CampusCartApp extends StatelessWidget {
  const CampusCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusCart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // ===== NAMED ROUTES =====
      // The app starts at '/', and we can navigate to the others by name.
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/product-details': (context) => const ProductDetailsScreen(),
        '/add-listing': (context) => const AddListingScreen(),
      },
    );
  }
}