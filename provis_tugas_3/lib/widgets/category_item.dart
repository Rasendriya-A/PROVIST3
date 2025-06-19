import 'package:flutter/material.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';

class CategoryItem extends StatelessWidget {
  final String label;
  final String imageUrl;

  const CategoryItem({required this.label, required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.brown.shade100,
            backgroundImage:
                imageUrl.startsWith('http')
                    ? NetworkImage(imageUrl) as ImageProvider
                    : AssetImage(imageUrl),
            onBackgroundImageError: (exception, stackTrace) {
              print('Error loading category image: $imageUrl');
            },
            child:
                imageUrl.startsWith('http') || imageUrl.startsWith('assets/')
                    ? null
                    : Icon(
                      Icons.category,
                      color: Colors.brown.shade300,
                      size: 24,
                    ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.categoryLabel),
        ],
      ),
    );
  }
}
