// ============================================================
// PART B - Complete Demo
// Purpose: Uses all the classes/mixins/async we've built.
// ============================================================

import 'models/user.dart';
import 'models/seller.dart';
import 'models/buyer.dart';
import 'models/product.dart';
import 'services/product_service.dart';

void main() async {
  print('===== CampusCart Part B Demo =====\n');

  // --------------------------------------------------
  // 1. INHERITANCE - User base class
  // --------------------------------------------------
  print('--- 1. Inheritance: User, Seller, Buyer ---');

  User genericUser = User(
    id: 'U001',
    fullName: 'Generic User',
    email: 'user@ur.ac.rw',
    university: 'University of Rwanda',
  );
  print(genericUser);
  print('Display: ${genericUser.getDisplayName()}');
  print('');

  Seller seller = Seller(
    id: 'S001',
    fullName: 'John Kalisa',
    email: 'john@ur.ac.rw',
    university: 'University of Rwanda',
    totalSales: 12,
    averageRating: 4.8,
    isVerified: true,
  );
  print(seller);
  print('Display: ${seller.getDisplayName()}');
  seller.postListing('Calculus Textbook');
  seller.recordSale();
  print('');

  Buyer buyer = Buyer(
    id: 'B001',
    fullName: 'Alice Mukamana',
    email: 'alice@ur.ac.rw',
    university: 'University of Rwanda',
    totalPurchases: 3,
  );
  print(buyer);
  buyer.addToFavorites('P001');
  buyer.addToFavorites('P002');
  buyer.makeOffer('Calculus Textbook', 4500);
  print('');

  // --------------------------------------------------
  // 2. MIXINS - Rateable + Timestamped
  // --------------------------------------------------
  print('--- 2. Mixins: Rateable + Timestamped ---');

  Product textbook = Product(
    id: 'P001',
    title: 'Calculus Textbook',
    description: 'Like new, used one semester',
    priceInRwf: 5000,
    category: 'Books',
    condition: 'Like New',
    sellerId: 'S001',
    sellerName: 'John Kalisa',
    location: 'Hostel B',
  );

  // Using methods from Rateable mixin
  textbook.addRating(5.0);
  textbook.addRating(4.5);
  textbook.addRating(4.0);
  textbook.addRating(6.0); // invalid - should be rejected

  print('Average rating: ${textbook.averageRating}');
  print('Star display: ${textbook.starDisplay}');
  print('Highly rated? ${textbook.isHighlyRated}');

  // Using features from Timestamped mixin
  print('Posted time: ${textbook.postedTimeAgo}');
  print('');

  print(textbook.fullSummary());
  print('');

  // --------------------------------------------------
  // 3. ASYNC/AWAIT - Fetching products
  // --------------------------------------------------
  print('--- 3. Async/Await: Fetching products ---');

  ProductService service = ProductService();

  // Await the Future to get the actual list
  List<Product> allProducts = await service.fetchAllProducts();
  print('\nTotal products fetched: ${allProducts.length}');
  for (var p in allProducts) {
    print('  • ${p.title} - ${p.priceInRwf} RWF');
  }
  print('');

  // Fetch a single product
  print('--- Fetching single product ---');
  Product? one = await service.fetchProductById('P002');
  if (one != null) {
    print('Got: ${one.title} by ${one.sellerName}');
  }
  print('');

  // Search products
  print('--- Searching for "laptop" ---');
  List<Product> searchResults = await service.searchProducts('laptop');
  for (var p in searchResults) {
    print('  • ${p.title}');
  }
  print('');

  // Post a new product
  print('--- Posting a new product ---');
  Product newProduct = Product(
    id: 'P005',
    title: 'Scientific Calculator',
    description: 'Casio fx-991, barely used',
    priceInRwf: 15000,
    category: 'Electronics',
    condition: 'Like New',
    sellerId: 'S001',
    sellerName: 'John Kalisa',
    location: 'Hostel B',
  );
  bool success = await service.postProduct(newProduct);
  print('Post result: ${success ? "SUCCESS" : "FAILED"}');
  print('');

  print('===== End of Part B Demo =====');
}