// ============================================================
// CampusCart - Entry Point
// Team: DevDynasty
// Phase 6: Added Firebase initialization
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
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
import 'screens/favorites_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/conversation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===== INITIALIZE FIREBASE =====
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ===== INITIALIZE HIVE =====
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox<Product>('products');
  await Hive.openBox('meta');
  await Hive.openBox<String>('favorites');

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
          '/favorites': (context) => const FavoritesScreen(),
          // Phase 9 - Real-time chat
          '/messages': (context) => const MessagesScreen(),
          '/conversation': (context) => const ConversationScreen(),
        },
      ),
    );
  }
}