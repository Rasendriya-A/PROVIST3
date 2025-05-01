import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  const ProductItem({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.red)),
        ],
      ),
    );
  }
}
