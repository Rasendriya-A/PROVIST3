// models/transaction.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum TransactionStatus {
  waitingApproval, // menunggu approval
  approved, // sudah diterima
  inProgress, // sedang dipinjam
  completed, // sudah dikembalikan
  damaged, // terlambat/rusak
}

class Transaction {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final List<TransactionItem> items;
  final TransactionStatus status;
  final double totalAmount;
  final String paymentMethod;
  final bool isRated;
  final String? notes;

  Transaction({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.items,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    this.isRated = false,
    this.notes,
  });

  int get duration {
    return endDate.difference(startDate).inDays;
  }

  String get statusText {
    switch (status) {
      case TransactionStatus.waitingApproval:
        return 'Menunggu Approval';
      case TransactionStatus.approved:
        return 'Sudah Diterima';
      case TransactionStatus.inProgress:
        return 'Sedang Dipinjam';
      case TransactionStatus.completed:
        return 'Sudah Dikembalikan';
      case TransactionStatus.damaged:
        return 'Terlambat/Rusak';
    }
  }

  Color get statusColor {
    switch (status) {
      case TransactionStatus.waitingApproval:
        return const Color(0xFFFF9800); // Orange
      case TransactionStatus.approved:
        return const Color(0xFF4CAF50); // Green
      case TransactionStatus.inProgress:
        return const Color(0xFF2196F3); // Blue
      case TransactionStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case TransactionStatus.damaged:
        return const Color(0xFFF44336); // Red
    }
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'items': items.map((item) => item.toMap()).toList(),
      'status': status.index,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'isRated': isRated,
      'notes': notes,
    };
  }

  // Create from Firestore document
  factory Transaction.fromMap(String id, Map<String, dynamic> map) {
    return Transaction(
      id: id,
      userId: map['userId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      items:
          (map['items'] as List)
              .map((item) => TransactionItem.fromMap(item))
              .toList(),
      status: TransactionStatus.values[map['status'] ?? 0],
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      isRated: map['isRated'] ?? false,
      notes: map['notes'],
    );
  }
}

// models/transaction_item.dart
class TransactionItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  TransactionItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  // Create from Firestore document
  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
    );
  }
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
