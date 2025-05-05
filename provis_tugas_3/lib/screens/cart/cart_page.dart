// screens/cart/cart_page.dart
import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/cart_item_model.dart';
import 'package:provis_tugas_3/models/checkout_model.dart';
import 'package:provis_tugas_3/routes/app_routes.dart';
import 'package:provis_tugas_3/screens/cart/services/cart_service.dart';
import 'package:provis_tugas_3/widgets/cart_item.dart';

class RentalCartPage extends StatefulWidget {
  const RentalCartPage({Key? key}) : super(key: key);

  @override
  State<RentalCartPage> createState() => _RentalCartPageState();
}

class _RentalCartPageState extends State<RentalCartPage> {
  final CartService _cartService = CartService();
  late List<RentalItem> _items;

  // Date selection properties
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _items = _cartService.getCartItems();
  }

  // Date selection methods
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: _cartService.getDatePickerTheme(context),
          child: child!,
        );
      },
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        // If end date is before start date or not set, update it
        if (endDate == null || endDate!.isBefore(startDate!)) {
          endDate = startDate!.add(Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          endDate ??
          (startDate != null
              ? startDate!.add(Duration(days: 1))
              : now.add(Duration(days: 1))),
      firstDate: startDate ?? now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: _cartService.getDatePickerTheme(context),
          child: child!,
        );
      },
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  // Helper getters
  int get rentalDuration =>
      _cartService.calculateRentalDuration(startDate, endDate);

  double get _subtotal =>
      _cartService.calculateSubtotal(_items, startDate, endDate);

  List<RentalItem> get _selectedItems => _cartService.getSelectedItems(_items);

  // Navigate to checkout and pass relevant data
  void _navigateToCheckout() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select rental dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pass all necessary data as a Map instead of custom object
    final checkoutData = {
      'items': _selectedItems
          .map(
            (item) => {
              'productName': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'imageUrl': item.imageUrl,
            },
          )
          .toList(),
      'startDate': startDate!,
      'endDate': endDate!,
      'paymentMethod': 'Transfer', // Default payment method
      'subtotal': _subtotal,
      'serviceFee': _subtotal * 0.007, // Example service fee calculation
      'total': _subtotal * 1.007, // Subtotal + service fee
    };

    Navigator.pushNamed(
      context,
      AppRoutes.checkout,
      arguments: checkoutData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4B6043),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(
              context,
            ); // This will navigate back to the previous screen
          },
        ),
        title: Text('Keranjang Saya', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return CartItemWidget(
                  item: item,
                  onCheckboxChanged: (bool? value) {
                    setState(() {
                      item.isSelected = value ?? false;
                    });
                  },
                  onDecreaseQuantity: () {
                    setState(() {
                      if (item.quantity > 1) {
                        item.quantity--;
                      }
                    });
                  },
                  onIncreaseQuantity: () {
                    setState(() {
                      item.quantity++;
                    });
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lama Sewa',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                startDate == null
                                    ? 'Tanggal Ambil'
                                    : '${startDate!.day}/${startDate!.month}/${startDate!.year}',
                                style: TextStyle(
                                  color:
                                      startDate == null
                                          ? Colors.grey[600]
                                          : Colors.black87,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey[600],
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectEndDate(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                endDate == null
                                    ? 'Tanggal Akhir'
                                    : '${endDate!.day}/${endDate!.month}/${endDate!.year}',
                                style: TextStyle(
                                  color:
                                      endDate == null
                                          ? Colors.grey[600]
                                          : Colors.black87,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey[600],
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subtotal:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp ${_cartService.formatNumber(_subtotal)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        if (rentalDuration > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '${rentalDuration} hari',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _navigateToCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4B6043),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
