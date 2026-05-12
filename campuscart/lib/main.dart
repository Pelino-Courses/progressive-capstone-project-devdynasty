// ============================================================
// CampusCart - Entry Point
// Team: DevDynasty
// Phase 2: Added Provider state management
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';

import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/add_listing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const CampusCartApp());
}

class CampusCartApp extends StatelessWidget {
  const CampusCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ===== PROVIDERS WRAP THE ENTIRE APP =====
    // MultiProvider lets us register multiple providers at once.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'CampusCart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/': (context) => const HomeScreen(),
          '/product-details': (context) => const ProductDetailsScreen(),
          '/add-listing': (context) => const AddListingScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}