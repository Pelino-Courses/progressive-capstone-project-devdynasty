// ============================================================
// PART A - Dart Fundamentals
// File: collections_demo.dart
// Purpose: Demonstrates Lists, Maps, and Sets using
//          CampusCart marketplace examples.
// ============================================================

void main() {
  print('===== CampusCart Collections Demo =====\n');

  // ------------------------------------------------------------
  // 1. LISTS - ordered collection of items
  // ------------------------------------------------------------
  // Lists are like arrays. Items have an order and can repeat.

  List<String> categories = [
    'Books',
    'Clothing',
    'Electronics',
    'Furniture',
    'Others',
  ];

  print('--- Categories (List) ---');
  print('All categories: $categories');
  print('First category: ${categories[0]}');
  print('Total categories: ${categories.length}');

  // Add to a list
  categories.add('Food');
  print('After adding "Food": $categories');

  // Remove from a list
  categories.remove('Others');
  print('After removing "Others": $categories');

  // Check if list contains an item
  bool hasBooks = categories.contains('Books');
  print('Contains Books? $hasBooks');
  print('');

  // ------------------------------------------------------------
  // 2. LIST OF NUMBERS - practical example with prices
  // ------------------------------------------------------------

  List<int> productPrices = [5000, 12000, 3500, 25000, 8000];

  print('--- Product Prices (List of int) ---');
  print('All prices: $productPrices RWF');

  // Sum all prices using reduce
  int totalValue = productPrices.reduce((a, b) => a + b);
  print('Total inventory value: $totalValue RWF');

  // Find the cheapest using reduce
  int cheapest = productPrices.reduce((a, b) => a < b ? a : b);
  print('Cheapest item: $cheapest RWF');

  // Filter items using where
  List<int> affordable = productPrices.where((p) => p < 10000).toList();
  print('Products under 10,000 RWF: $affordable');
  print('');

  // ------------------------------------------------------------
  // 3. MAPS - key-value pairs
  // ------------------------------------------------------------
  // Maps are like dictionaries. Each key is unique and has a value.

  Map<String, int> categoryItemCount = {
    'Books': 45,
    'Clothing': 32,
    'Electronics': 18,
    'Furniture': 9,
  };

  print('--- Category Item Counts (Map) ---');
  print('Full map: $categoryItemCount');
  print('Books count: ${categoryItemCount['Books']}');

  // Add a new entry
  categoryItemCount['Food'] = 12;
  print('After adding Food: $categoryItemCount');

  // Update a value
  categoryItemCount['Books'] = 50;
  print('After updating Books: $categoryItemCount');

  // Loop through a map
  print('\nLooping through categories:');
  categoryItemCount.forEach((category, count) {
    print('  $category -> $count items');
  });
  print('');

  // ------------------------------------------------------------
  // 4. MAP WITH MIXED VALUES - a product record
  // ------------------------------------------------------------

  Map<String, dynamic> product = {
    'id': 'P001',
    'title': 'Calculus Textbook',
    'price': 5000,
    'condition': 'Like New',
    'inStock': true,
    'sellerRating': 4.5,
  };

  print('--- Single Product (Map with mixed values) ---');
  print('Product title: ${product['title']}');
  print('Product price: ${product['price']} RWF');
  print('Seller rating: ${product['sellerRating']}');
  print('');

  // ------------------------------------------------------------
  // 5. SETS - unique items only, no order
  // ------------------------------------------------------------
  // Sets automatically remove duplicates.

  Set<String> uniqueSellers = {
    'John Kalisa',
    'Alice Mukamana',
    'John Kalisa',  // duplicate - will be ignored
    'Bob Nshimiye',
  };

  print('--- Unique Sellers (Set) ---');
  print('Sellers: $uniqueSellers');
  print('Total unique sellers: ${uniqueSellers.length}');

  // Add to a set
  uniqueSellers.add('Claire Uwase');
  uniqueSellers.add('John Kalisa'); // duplicate ignored
  print('After adding: $uniqueSellers');
  print('');

  // ------------------------------------------------------------
  // 6. LIST OF MAPS - our product catalog
  // ------------------------------------------------------------
  // This is a very common pattern: a list where each item is a map.

  List<Map<String, dynamic>> productCatalog = [
    {'title': 'Calculus Textbook', 'price': 5000, 'category': 'Books'},
    {'title': 'Nike Shoes', 'price': 25000, 'category': 'Clothing'},
    {'title': 'Laptop Charger', 'price': 8000, 'category': 'Electronics'},
    {'title': 'Study Desk', 'price': 35000, 'category': 'Furniture'},
  ];

  print('--- Product Catalog (List of Maps) ---');
  for (var item in productCatalog) {
    print('  ${item['title']} - ${item['price']} RWF (${item['category']})');
  }

  // Filter by category
  var booksOnly = productCatalog.where((p) => p['category'] == 'Books').toList();
  print('\nBooks only: $booksOnly');
  print('');

  print('===== End of Collections Demo =====');
}