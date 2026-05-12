// ============================================================
// CampusCart - Phase 1
// File: profile_screen.dart
// Purpose: User profile + My Listings + Sold Items.
//          Uses TabBar for switching between tabs.
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProductService _productService = ProductService();

  // Mock user data (will come from Firebase Auth in Phase 6)
  final String _userName = 'John Kalisa';
  final String _university = 'University of Rwanda';
  final double _rating = 4.8;
  final int _totalSales = 12;
  final int _activeListings = 5;

  List<Product> _myListings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMyListings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // For now we just load all products and pretend they belong to this user.
  // In Phase 3 (SQLite) and Phase 7 (Firestore) we'll filter by sellerId.
  Future<void> _loadMyListings() async {
    setState(() => _isLoading = true);
    final all = await _productService.fetchAllProducts();
    setState(() {
      _myListings = all;
      _isLoading = false;
    });
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text('You will need to sign in again to access your account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              // Go to login, clearing back-stack
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== PROFILE HEADER =====
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    _userName[0],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Name + Verified badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified,
                        color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 4),

                // University
                Text(
                  _university,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),

                // Verified Seller text
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Verified Seller',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== STATS ROW =====
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                _statCard('Sales', '$_totalSales', Icons.shopping_bag_outlined),
                _statCard('Listings', '$_activeListings', Icons.list_alt),
                _statCard('Rating', '$_rating', Icons.star, isLast: true),
              ],
            ),
          ),

          // ===== EDIT PROFILE BUTTON =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit Profile coming soon')),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          // ===== TABS =====
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'My Listings'),
                Tab(text: 'Sold Items'),
              ],
            ),
          ),

          // ===== TAB CONTENT =====
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // --- MY LISTINGS TAB ---
                      _myListings.isEmpty
                          ? _emptyState('No listings yet',
                              'Tap the + button to add your first product')
                          : ListView.builder(
                              itemCount: _myListings.length,
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: _myListings[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/product-details',
                                      arguments: _myListings[index],
                                    );
                                  },
                                );
                              },
                            ),

                      // --- SOLD ITEMS TAB ---
                      _emptyState('No sold items yet',
                          'Items you sell will appear here'),
                    ],
                  ),
          ),
        ],
      ),

      // ===== FAB =====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add-listing');
          if (result == true) _loadMyListings();
        },
        icon: const Icon(Icons.add),
        label: const Text('New Listing'),
      ),
    );
  }

  // Helper - one stat card
  Widget _statCard(String label, String value, IconData icon,
      {bool isLast = false}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  right: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper - empty state widget
  Widget _emptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}