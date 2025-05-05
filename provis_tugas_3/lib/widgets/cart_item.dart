// widgets/cart_item.dart
import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/cart_item_model.dart';
import 'package:provis_tugas_3/screens/cart/services/cart_service.dart';

class CartItemWidget extends StatelessWidget {
  final RentalItem item;
  final Function(bool?) onCheckboxChanged;
  final Function() onDecreaseQuantity;
  final Function() onIncreaseQuantity;
  final CartService cartService = CartService();

  CartItemWidget({
    Key? key,
    required this.item,
    required this.onCheckboxChanged,
    required this.onDecreaseQuantity,
    required this.onIncreaseQuantity,
  }) : super(key: key);

  // Helper method to build item images with fallbacks
  Widget _buildItemImage(String itemName, String imageUrl) {
    // For testing without assets, use placeholder colors based on item type
    Color placeholderColor;
    IconData placeholderIcon;

    if (itemName == 'Tenda') {
      placeholderColor = Colors.brown[200]!;
      placeholderIcon = Icons.home_outlined;
    } else if (itemName == 'Kitchenware') {
      placeholderColor = Colors.orange[200]!;
      placeholderIcon = Icons.soup_kitchen_outlined;
    } else {
      placeholderColor = Colors.blue[200]!;
      placeholderIcon = Icons.bed_outlined;
    }

    // Try to load the asset, fallback to colored placeholder
    return Image.asset(
      imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 80,
          height: 80,
          color: placeholderColor,
          child: Icon(placeholderIcon, color: Colors.white, size: 40),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(
              value: item.isSelected,
              activeColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: onCheckboxChanged,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildItemImage(item.name, item.imageUrl),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rp ${cartService.formatNumber(item.price)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: onDecreaseQuantity,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.remove, size: 16),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                InkWell(
                  onTap: onIncreaseQuantity,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.add, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
