// widgets/cart_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provis_tugas_3/models/cart_item_model.dart';

class CartItem extends StatelessWidget {
  final RentalItem item;
  final Function(int) onQuantityChanged;
  final Function(bool) onToggle;
  final Function() onRemove;

  const CartItem({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onToggle,
    required this.onRemove,
  });

  String formatNumber(double number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  // Helper method to build item images with fallbacks
  Widget _buildItemImage(String itemName, String imageUrl) {
    // For testing without assets, use placeholder colors based on item type
    Color placeholderColor;
    IconData placeholderIcon;

    if (itemName.toLowerCase().contains('tenda')) {
      placeholderColor = Colors.brown[200]!;
      placeholderIcon = Icons.home_outlined;
    } else if (itemName.toLowerCase().contains('kitchen')) {
      placeholderColor = Colors.orange[200]!;
      placeholderIcon = Icons.soup_kitchen_outlined;
    } else if (itemName.toLowerCase().contains('sleeping')) {
      placeholderColor = Colors.blue[200]!;
      placeholderIcon = Icons.bed_outlined;
    } else {
      placeholderColor = Colors.grey[300]!;
      placeholderIcon = Icons.shopping_bag_outlined;
    }

    // Try to load the image (could be network or asset)
    if (imageUrl.startsWith('http')) {
      return Image.network(
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
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: item.isSelected,
              onChanged: (value) => onToggle(value ?? false),
              activeColor: const Color(0xFF4B6543),
            ),

            // Item image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildItemImage(item.name, item.imageUrl),
            ),

            const SizedBox(width: 12),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${formatNumber(item.price)} / hari',
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Quantity controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (item.quantity > 1) {
                                onQuantityChanged(item.quantity - 1);
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed:
                                () => onQuantityChanged(item.quantity + 1),
                            icon: const Icon(Icons.add_circle_outline),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ),

                      // Remove button
                      IconButton(
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Hapus Item'),
                                content: Text(
                                  'Hapus ${item.name} dari keranjang?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      onRemove();
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
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
    );
  }
}
