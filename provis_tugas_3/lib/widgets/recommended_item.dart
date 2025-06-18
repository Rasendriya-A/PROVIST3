import 'package:flutter/material.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/screens/product/detail_fixed.dart';

class RecommendedItem extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? price;
  final ProductItemData? product;

  const RecommendedItem({
    this.imageUrl,
    this.title,
    this.description,
    this.price,
    this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use product data if available, otherwise use individual parameters
    final displayImageUrl = product?.imageUrl ?? imageUrl ?? '';
    final displayTitle = product?.name ?? title ?? '';
    final displayDescription = product?.description ?? description ?? '';
    final displayPrice = product?.price.toString() ?? price ?? '';

    return GestureDetector(      onTap: product != null ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailFixed(productId: product!.id),
          ),
        );
      } : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: displayImageUrl.isNotEmpty
                  ? Image.network(
                      displayImageUrl,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 8),
            // Bagian teks
            Text(
              displayTitle,
              style: AppTextStyles.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              displayDescription,
              style: AppTextStyles.small,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            const SizedBox(height: 4),
            Text(
              "Rp $displayPrice",
              style: AppTextStyles.button.copyWith(color: Colors.green),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
