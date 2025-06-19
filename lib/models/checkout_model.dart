// lib/models/checkout_model.dart

class RentalItemModel {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  RentalItemModel({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}

class RentalPeriodModel {
  final DateTime startDate;
  final DateTime endDate;

  RentalPeriodModel({required this.startDate, required this.endDate});

  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }
}

class PaymentMethodModel {
  final String name;
  final String iconPath;

  PaymentMethodModel({required this.name, required this.iconPath});
}

class CheckoutSummaryModel {
  final List<RentalItemModel> items;
  final RentalPeriodModel rentalPeriod;
  final PaymentMethodModel paymentMethod;
  final double subtotal;
  final double serviceFee;
  final double total;

  CheckoutSummaryModel({
    required this.items,
    required this.rentalPeriod,
    required this.paymentMethod,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}
