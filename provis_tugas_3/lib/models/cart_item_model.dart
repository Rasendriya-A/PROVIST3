// models/cart_item_model.dart
class RentalItem {
  final String? productId;
  final String name;
  final String imageUrl;
  final double price;
  bool isSelected;
  int quantity;

  RentalItem({
    this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.isSelected = false,
    this.quantity = 1,
  });
}

// Class to pass data to the checkout screen
class CheckoutArguments {
  final List<RentalItem> selectedItems;
  final DateTime startDate;
  final DateTime endDate;
  final double subtotal;

  CheckoutArguments({
    required this.selectedItems,
    required this.startDate,
    required this.endDate,
    required this.subtotal,
  });
}
