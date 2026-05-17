// ============================================================
// Phase 8 - Firebase Storage Service
// File: storage_service.dart
// Purpose: Wrapper around Firebase Storage for product images.
//
// Why this exists (the problem Phase 8 solves):
//   Until Phase 7, product photos were stored as raw bytes
//   (imageBytes) INSIDE the Firestore document. Firestore
//   documents have a hard 1 MB size limit, so a real photo
//   would eventually break saving the product.
//
//   Firebase Storage is built for files. Phase 8 uploads the
//   image to Storage, gets back a download URL, and stores
//   only that small URL string in Firestore. Tiny document,
//   no size limit problems.
//
// This mirrors how ProductFirestoreService wraps Firestore:
// all firebase_storage calls live in this ONE file.
// ============================================================

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  // The root of our Firebase Storage bucket.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // All product images go under this folder in the bucket.
  static const String _productImagesFolder = 'product_images';

  /// Upload a product image (as bytes) to Firebase Storage.
  ///
  /// [productId] is used as the file name so each product has
  /// exactly one image file (uploading again overwrites it).
  ///
  /// Returns the public download URL on success, or throws on
  /// failure (the caller decides how to handle it).
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List imageBytes,
  }) async {
    // e.g. product_images/P1737041234567.jpg
    final ref = _storage
        .ref()
        .child(_productImagesFolder)
        .child('$productId.jpg');

    // SettableMetadata tells Storage this is a JPEG image.
    final uploadTask = await ref.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    // Get the URL anyone can use to view the image.
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Delete a product's image from Storage.
  ///
  /// Called when a product is deleted, so we don't leave
  /// orphaned image files in the bucket. Safe to call even if
  /// the image doesn't exist - we swallow that specific error.
  Future<void> deleteProductImage(String productId) async {
    try {
      final ref = _storage
          .ref()
          .child(_productImagesFolder)
          .child('$productId.jpg');
      await ref.delete();
    } on FirebaseException catch (e) {
      // 'object-not-found' just means there was no image to
      // delete (e.g. a product posted without a photo). That
      // is not a real error, so ignore it. Re-throw anything
      // else so genuine problems are not hidden.
      if (e.code != 'object-not-found') rethrow;
    }
  }
}
