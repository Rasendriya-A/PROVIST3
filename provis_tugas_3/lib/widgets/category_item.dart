import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String label;
  final String imageUrl;

  const CategoryItem({
    required this.label,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.brown.shade100,
            backgroundImage: AssetImage(imageUrl),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
