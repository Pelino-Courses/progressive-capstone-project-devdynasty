// ============================================================
// Phase 5 - ProductCard with favorite (heart) button
// Updated in Phase 8: shows images from Firebase Storage URLs.
// File: product_card.dart
// ============================================================

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Watch the provider so the heart icon updates instantly when toggled
    final productProvider = context.watch<ProductProvider>();
    final isFavorite = productProvider.isFavorite(product);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== PRODUCT IMAGE OR ICON =====
              // Phase 10: Hero tag shared with the details screen
              // for a smooth shared-element transition.
              Hero(
                tag: 'product-image-${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: _buildThumbnail(),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ===== PRODUCT INFO =====
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // ===== HEART (FAVORITE) BUTTON =====
                        GestureDetector(
                          onTap: () {
                            productProvider.toggleFavorite(product);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? AppTheme.errorColor
                                  : AppTheme.textSecondary,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${product.priceInRwf} RWF',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.condition,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person,
                            size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.sellerName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Phase 8: decide what to show for the product image.
  // Priority: Firebase Storage URL -> old local bytes -> icon.
  Widget _buildThumbnail() {
    if (product.hasNetworkImage) {
      return Image.network(
        product.imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        // Show a spinner while the image downloads.
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        // If the URL fails to load, fall back to the icon.
        errorBuilder: (context, error, stack) => _categoryIconWidget(),
      );
    }

    // Backward compatibility: older products stored raw bytes.
    if (product.hasImage) {
      return Image.memory(
        Uint8List.fromList(product.imageBytes!),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    return _categoryIconWidget();
  }

  Widget _categoryIconWidget() {
    return Icon(
      _categoryIcon(product.category),
      size: 40,
      color: AppTheme.primaryColor,
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Books':
        return Icons.menu_book;
      case 'Clothing':
        return Icons.checkroom;
      case 'Electronics':
        return Icons.devices;
      case 'Furniture':
        return Icons.chair;
      default:
        return Icons.shopping_bag;
    }
  }
}