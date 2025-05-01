import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/widgets/product_item.dart';

class HorizontalProductList extends StatelessWidget {
  final List<ProductItemData> products;

  const HorizontalProductList({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItem(
            name: product.name,
            price: product.price,
            imageUrl: product.imageUrl,
          );
        },
      ),
    );
  }
}
