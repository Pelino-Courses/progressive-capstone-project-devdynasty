// ============================================================
// CampusCart - Entry Point
// Team: DevDynasty
// Phase 3: Hive initialization with seeding flag box
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'theme/app_theme.dart';
import 'models/product.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';

import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/add_listing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===== INITIALIZE HIVE =====
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());

  // Open boxes
  await Hive.openBox<Product>('products');
  await Hive.openBox('meta'); // for app-level flags like 'hasSeeded'

  runApp(const CampusCartApp());
}

class CampusCartApp extends StatelessWidget {
  const CampusCartApp({super.key});

  @override
  Widget build(BuildContext context) {
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