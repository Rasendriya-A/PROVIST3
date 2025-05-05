// services/cart_service.dart
import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/cart_item_model.dart';

class CartService {
  // Mock data for rental items
  List<RentalItem> getCartItems() {
    return [
      RentalItem(
        name: 'Tenda',
        imageUrl: 'assets/images/items/tenda_1.jpg',
        price: 700000,
        isSelected: true,
      ),
      RentalItem(
        name: 'Tenda',
        imageUrl: 'assets/images/items/tenda_2.jpg',
        price: 700000,
        isSelected: true,
      ),
      RentalItem(
        name: 'Tenda',
        imageUrl: 'assets/images/items/tenda_3.jpg',
        price: 700000,
      ),
      RentalItem(
        name: 'Kitchenware',
        imageUrl: 'assets/images/items/kitchenware_1.jpg',
        price: 700000,
      ),
      RentalItem(
        name: 'Sleeping Bag',
        imageUrl: 'assets/images/items/sleeping_bag.jpg',
        price: 700000,
      ),
    ];
  }

  // Calculate rental duration in days
  int calculateRentalDuration(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return 0;
    return endDate.difference(startDate).inDays;
  }

  // Calculate subtotal based on selected items and duration
  double calculateSubtotal(
    List<RentalItem> items,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    double total = 0;
    for (var item in items) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    }

    // If dates are selected, multiply by the number of days
    if (startDate != null && endDate != null) {
      int days = calculateRentalDuration(startDate, endDate);
      if (days > 0) {
        return total * days;
      }
    }

    return total;
  }

  // Get only the selected items
  List<RentalItem> getSelectedItems(List<RentalItem> items) {
    return items.where((item) => item.isSelected).toList();
  }

  // Helper function to format numbers with period separators
  String formatNumber(double number) {
    String numberStr = number.toInt().toString();
    final result = StringBuffer();

    for (int i = 0; i < numberStr.length; i++) {
      if (i > 0 && (numberStr.length - i) % 3 == 0) {
        result.write('.');
      }
      result.write(numberStr[i]);
    }

    return result.toString();
  }

  // Date picker theme
  ThemeData getDatePickerTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: Color(0xFF4B6043), // Header background color
        onPrimary: Colors.white, // Header text color
        onSurface: Colors.black, // Calendar text color
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFF4B6043), // Button text color
        ),
      ),
    );
  }
}
