// ============================================================
// PART A - Dart Fundamentals
// File: functions_demo.dart
// Purpose: Demonstrates different kinds of functions using
//          CampusCart marketplace examples.
// ============================================================

void main() {
  print('===== CampusCart Functions Demo =====\n');

  // 1. BASIC FUNCTION
  print('--- 1. Basic Function ---');
  int total = calculateTotalPrice(5000, 3);
  print('Total for 3 items at 5000 RWF each: $total RWF');
  print('');

  // 2. ARROW FUNCTION
  print('--- 2. Arrow Function ---');
  double discounted = applyDiscount(10000, 15);
  print('10000 RWF with 15% discount: $discounted RWF');
  print('');

  // 3. NAMED PARAMETERS
  print('--- 3. Named Parameters ---');
  String listing = formatListing(
    title: 'Nike Shoes',
    price: 25000,
    condition: 'Like New',
  );
  print(listing);
  print('');

  // 4. OPTIONAL POSITIONAL PARAMETERS
  print('--- 4. Optional Positional Parameters ---');
  print(greetSeller('John'));
  print(greetSeller('Alice', 'Verified Seller'));
  print('');

  // 5. DEFAULT VALUES
  print('--- 5. Default Parameter Values ---');
  print(buildProductTag(title: 'Textbook'));
  print(buildProductTag(title: 'Laptop', category: 'Electronics'));
  print('');

  // 6. BOOLEAN RETURN
  print('--- 6. Boolean Return ---');
  print('Is 4.5 a valid rating? ${isValidRating(4.5)}');
  print('Is 7.0 a valid rating? ${isValidRating(7.0)}');
  print('');

  // 7. RETURNING A LIST
  print('--- 7. Returning a List ---');
  List<Map<String, dynamic>> catalog = [
    {'title': 'Calculus Book', 'price': 5000, 'category': 'Books'},
    {'title': 'Nike Shoes', 'price': 25000, 'category': 'Clothing'},
    {'title': 'Charger', 'price': 8000, 'category': 'Electronics'},
    {'title': 'Novel', 'price': 3500, 'category': 'Books'},
  ];
  var booksOnly = filterByCategory(catalog, 'Books');
  print('Books in catalog:');
  for (var book in booksOnly) {
    print('  - ${book['title']} (${book['price']} RWF)');
  }
  print('');

  // 8. HIGHER-ORDER FUNCTION
  print('--- 8. Higher-Order Function ---');
  List<int> prices = [5000, 12000, 3500, 25000];
  int highest = findExtreme(prices, (a, b) => a > b);
  int lowest = findExtreme(prices, (a, b) => a < b);
  print('Highest price: $highest RWF');
  print('Lowest price: $lowest RWF');
  print('');

  // 9. ANONYMOUS FUNCTION
  print('--- 9. Anonymous Function with forEach ---');
  List<String> categories = ['Books', 'Clothing', 'Electronics'];
  categories.forEach((category) {
    print('Category: $category');
  });
  print('');

  print('===== End of Functions Demo =====');
}

// ============================================================
// FUNCTION DEFINITIONS
// ============================================================

int calculateTotalPrice(int pricePerItem, int quantity) {
  return pricePerItem * quantity;
}

double applyDiscount(double price, double percentage) =>
    price - (price * percentage / 100);

String formatListing({
  required String title,
  required int price,
  required String condition,
}) {
  return 'Listing -> $title | $price RWF | $condition';
}

String greetSeller(String name, [String? badge]) {
  if (badge == null) {
    return 'Hello, $name!';
  }
  return 'Hello, $name ($badge)!';
}

String buildProductTag({required String title, String category = 'General'}) {
  return '[$category] $title';
}

bool isValidRating(double rating) {
  return rating >= 0 && rating <= 5;
}

List<Map<String, dynamic>> filterByCategory(
  List<Map<String, dynamic>> products,
  String category,
) {
  return products.where((p) => p['category'] == category).toList();
}

int findExtreme(List<int> numbers, bool Function(int, int) compare) {
  int result = numbers[0];
  for (int n in numbers) {
    if (compare(n, result)) {
      result = n;
    }
  }
  return result;
}