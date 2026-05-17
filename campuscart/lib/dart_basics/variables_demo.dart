// ============================================================
// PART A - Dart Fundamentals
// File: variables_demo.dart
// Purpose: Demonstrates Variables and Null Safety using
//          CampusCart marketplace examples.
// ============================================================

void main() {
  print('===== CampusCart Variables & Null Safety Demo =====\n');

  // ------------------------------------------------------------
  // 1. BASIC VARIABLE TYPES
  // ------------------------------------------------------------
  // Dart is strongly typed: each variable has a specific type.

  String productName = 'Calculus Textbook'; // text
  int priceInRwf = 5000;                    // whole number
  double rating = 4.5;                      // decimal number
  bool isAvailable = true;                  // true or false

  print('Product: $productName');
  print('Price: $priceInRwf RWF');
  print('Rating: $rating stars');
  print('Available: $isAvailable');
  print('');

  // ------------------------------------------------------------
  // 2. TYPE INFERENCE WITH 'var'
  // ------------------------------------------------------------
  // Dart can figure out the type automatically using 'var'.

  var sellerName = 'John Kalisa';   // Dart infers String
  var totalSales = 12;              // Dart infers int

  print('Seller: $sellerName (total sales: $totalSales)');
  print('');

  // ------------------------------------------------------------
  // 3. CONSTANTS - 'final' vs 'const'
  // ------------------------------------------------------------
  // 'final' = value set once at runtime, cannot change afterwards
  // 'const' = value known at compile time, cannot change ever

  final String universityName = 'University of Rwanda';
  const String currencySymbol = 'RWF';
  const double taxRate = 0.00; // no tax on campus marketplace

  print('University: $universityName');
  print('Currency: $currencySymbol');
  print('Tax Rate: $taxRate');
  print('');

  // ------------------------------------------------------------
  // 4. NULL SAFETY - Nullable vs Non-Nullable
  // ------------------------------------------------------------
  // By default, variables CANNOT be null.
  // Add '?' to make a variable nullable.

  String productTitle = 'Used Nike Shoes';   // cannot be null
  String? productDescription;                // CAN be null (starts as null)

  print('Title: $productTitle');
  print('Description (before set): $productDescription'); // prints null

  productDescription = 'Worn only twice, excellent condition';
  print('Description (after set): $productDescription');
  print('');

  // ------------------------------------------------------------
  // 5. NULL-AWARE OPERATORS
  // ------------------------------------------------------------

  // '??' - default value if null
  String? buyerNote;
  String displayNote = buyerNote ?? 'No note from buyer';
  print('Buyer Note: $displayNote');

  // '??=' - assign only if currently null
  String? deliveryLocation;
  deliveryLocation ??= 'Hostel B';
  print('Delivery Location: $deliveryLocation');

  // '?.' - safely access a property; returns null if variable is null
  String? sellerBio;
  int? bioLength = sellerBio?.length;
  print('Bio length (null-safe): $bioLength');

  // '!' - assert NOT null (use carefully)
  String? verifiedEmail = 'student@ur.ac.rw';
  String definitelyEmail = verifiedEmail!; // we promise it's not null
  print('Verified Email: $definitelyEmail');
  print('');

  // ------------------------------------------------------------
  // 6. STRING INTERPOLATION
  // ------------------------------------------------------------
  // Inserting variables directly into strings

  String summary =
      'Listing: $productName - $priceInRwf $currencySymbol - ${rating * 2}/10';
  print(summary);
  print('');

  print('===== End of Demo =====');
}