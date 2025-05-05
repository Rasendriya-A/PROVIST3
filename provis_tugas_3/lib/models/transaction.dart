// models/transaction.dart
class Transaction {
  final String id;
  final DateTime date;
  final List<TransactionItem> items;
  final String status; // "Disewa" or "Selesai"
  final int duration; // In days
  final bool isRated;

  Transaction({
    required this.id,
    required this.date,
    required this.items,
    required this.status,
    this.duration = 0,
    this.isRated = false,
  });

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalQuantity {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

// models/transaction_item.dart
class TransactionItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  TransactionItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}

// models/review.dart
class Review {
  final String transactionId;
  final int rating;
  final String comment;

  Review({
    required this.transactionId,
    required this.rating,
    required this.comment,
  });
}
