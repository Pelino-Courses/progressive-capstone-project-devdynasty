// ============================================================
// PART B - OOP & Data Models
// File: product_service.dart
// Purpose: Service class demonstrating async/await - simulates
//          fetching products from a server.
// ============================================================

import '../models/product.dart';

class ProductService {
  // Simulates fetching all products (like calling a real API)
  // Returns a Future<List<Product>> - a promise of a list of products
  Future<List<Product>> fetchAllProducts() async {
    print('⏳ Fetching products from server...');

    // Simulate network delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    // Simulate the server returning product data
    List<Product> products = [
      Product(
        id: 'P001',
        title: 'Calculus Textbook',
        description: 'Used for one semester, excellent condition. All pages intact.',
        priceInRwf: 5000,
        category: 'Books',
        condition: 'Like New',
        sellerId: 'S001',
        sellerName: 'John Kalisa',
        location: 'Hostel B',
      ),
      Product(
        id: 'P002',
        title: 'Nike Running Shoes',
        description: 'Size 42, worn twice. Still fresh.',
        priceInRwf: 25000,
        category: 'Clothing',
        condition: 'Like New',
        sellerId: 'S002',
        sellerName: 'Alice Mukamana',
        location: 'Hostel A',
      ),
      Product(
        id: 'P003',
        title: 'Laptop Charger - HP',
        description: 'Original HP charger, 65W. Fully working.',
        priceInRwf: 8000,
        category: 'Electronics',
        condition: 'Good',
        sellerId: 'S001',
        sellerName: 'John Kalisa',
        location: 'Campus Main',
      ),
      Product(
        id: 'P004',
        title: 'Study Desk',
        description: 'Wooden desk, 120cm x 60cm. Good for dorm rooms.',
        priceInRwf: 35000,
        category: 'Furniture',
        condition: 'Good',
        sellerId: 'S003',
        sellerName: 'Bob Nshimiye',
        location: 'Hostel C',
      ),
    ];

    print('✅ Products loaded successfully: ${products.length} items');
    return products;
  }

  // Simulates fetching a single product by ID
  Future<Product?> fetchProductById(String productId) async {
    print('⏳ Looking up product $productId...');
    await Future.delayed(const Duration(seconds: 1));

    List<Product> allProducts = await fetchAllProducts();

    try {
      Product found = allProducts.firstWhere((p) => p.id == productId);
      print('✅ Found: ${found.title}');
      return found;
    } catch (e) {
      print('❌ No product found with id $productId');
      return null;
    }
  }

  // Simulates searching products by keyword
  Future<List<Product>> searchProducts(String keyword) async {
    print('⏳ Searching for "$keyword"...');
    await Future.delayed(const Duration(milliseconds: 800));

    List<Product> allProducts = await fetchAllProducts();
    List<Product> matches = allProducts
        .where((p) =>
            p.title.toLowerCase().contains(keyword.toLowerCase()) ||
            p.description.toLowerCase().contains(keyword.toLowerCase()))
        .toList();

    print('✅ Search complete. Found ${matches.length} matches.');
    return matches;
  }

  // Simulates posting a new product (with potential failure)
  Future<bool> postProduct(Product product) async {
    print('⏳ Posting "${product.title}" to server...');
    await Future.delayed(const Duration(seconds: 1));

    // Simulate occasional failure (e.g. invalid price)
    if (product.priceInRwf <= 0) {
      print('❌ Failed: invalid price');
      return false;
    }

    print('✅ Product posted successfully');
    return true;
  }
}