// ============================================================
// PART C - Flutter Widgets & UI
// File: home_screen.dart
// Purpose: Main home screen - search, categories, product list.
// Updated in Part D to support named-route navigation.
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  // Category data - label + icon
  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.apps},
    {'label': 'Books', 'icon': Icons.menu_book},
    {'label': 'Clothing', 'icon': Icons.checkroom},
    {'label': 'Electronics', 'icon': Icons.devices},
    {'label': 'Furniture', 'icon': Icons.chair},
    {'label': 'Others', 'icon': Icons.shopping_bag},
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load products asynchronously using ProductService
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _productService.fetchAllProducts();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
      _isLoading = false;
    });
  }

  // Filter products by selected category
  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts =
            _allProducts.where((p) => p.category == category).toList();
      }
    });
  }

  // Filter products by search keyword
  void _searchProducts(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filterByCategory(_selectedCategory);
      } else {
        _filteredProducts = _allProducts
            .where((p) =>
                p.title.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== TOP APP BAR =====
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(width: 8),
            Text('CampusCart'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),

      // ===== MAIN BODY =====
      body: Column(
        children: [
          // --- Search bar ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _searchProducts,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchProducts('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // --- Category chips (horizontal scrollable row) ---
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return CategoryChip(
                  label: cat['label'],
                  icon: cat['icon'],
                  isSelected: _selectedCategory == cat['label'],
                  onTap: () => _filterByCategory(cat['label']),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // --- Section title ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory == 'All'
                      ? 'Recent Listings'
                      : _selectedCategory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${_filteredProducts.length} items',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // --- Product list ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadProducts,
                        child: ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: _filteredProducts[index],
                              onTap: () {
                                // Navigate to product details and pass the product
                                Navigator.pushNamed(
                                  context,
                                  '/product-details',
                                  arguments: _filteredProducts[index],
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      // ===== FLOATING ACTION BUTTON (Add New Listing) =====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate to add listing. When user returns, refresh products.
          final result = await Navigator.pushNamed(context, '/add-listing');
          if (result == true) {
            _loadProducts();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Post'),
        backgroundColor: AppTheme.primaryColor,
      ),

      // ===== BOTTOM NAVIGATION BAR =====
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          // Placeholder for future navigation
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
              icon: Icon(Icons.list_alt), label: 'Listings'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}