// lib/widgets/recommended_item.dart

import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';

class RecommendedItem extends StatelessWidget {
  final ProductItemData product;
  final VoidCallback? onTap;

  const RecommendedItem({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            Expanded(
              child: SizedBox(
                // Menggunakan SizedBox agar bisa memberi width double.infinity
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            // Detail produk
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    // MENGGANTI AppTextStyles.body MENJADI AppTextStyles.label
                    style: AppTextStyles.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.price,
                    // MENGGANTI AppTextStyles.body MENJADI AppTextStyles.label
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold, // Harga dibuat tebal
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
