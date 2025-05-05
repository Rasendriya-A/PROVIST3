// services/transaction_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/transaction.dart';

class TransactionService extends ChangeNotifier {
  List<Transaction> _transactions = [];
  String _activeFilter = 'Semua Status';

  List<Transaction> get transactions {
    if (_activeFilter == 'Semua Status') {
      return _transactions;
    } else {
      return _transactions.where((t) => t.status == _activeFilter).toList();
    }
  }

  String get activeFilter => _activeFilter;

  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    // In a real app, this would fetch from an API
    // For now, we'll return mock data based on the screenshots
    await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay

    _transactions = [
      Transaction(
        id: 't1',
        date: DateTime(2024, 4, 16),
        status: 'Disewa',
        duration: 4,
        items: [
          TransactionItem(
            id: 'p1',
            name: 'Tenda',
            imageUrl: 'assets/images/items/tenda_1.jpg',
            price: 200000,
            quantity: 1,
          ),
          TransactionItem(
            id: 'p2',
            name: 'Tas',
            imageUrl: 'assets/images/items/tas_1.jpg',
            price: 200000,
            quantity: 1,
          ),
        ],
      ),
      Transaction(
        id: 't2',
        date: DateTime(2024, 4, 15),
        status: 'Selesai',
        isRated: false,
        items: [
          TransactionItem(
            id: 'p1',
            name: 'Tenda',
            imageUrl: 'assets/images/items/tenda_2.jpg',
            price: 200000,
            quantity: 1,
          ),
          TransactionItem(
            id: 'p3',
            name: 'Kitchenware',
            imageUrl: 'assets/images/items/kitchenware_1.jpg',
            price: 200000,
            quantity: 1,
          ),
        ],
      ),
      Transaction(
        id: 't3',
        date: DateTime(2024, 4, 13),
        status: 'Selesai',
        isRated: false,
        items: [
          TransactionItem(
            id: 'p4',
            name: 'Tas',
            imageUrl: 'assets/images/items/tas_2.jpg',
            price: 200000,
            quantity: 1,
          ),
          TransactionItem(
            id: 'p5',
            name: 'Sepatu',
            imageUrl: 'assets/images/items/sepatu_1.jpg',
            price: 200000,
            quantity: 1,
          ),
        ],
      ),
    ];

    notifyListeners();
  }

  Future<void> submitReview(Review review) async {
    // In a real app, this would send to an API
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    // Find the transaction and mark it as rated
    final index = _transactions.indexWhere((t) => t.id == review.transactionId);
    if (index != -1) {
      final transaction = _transactions[index];

      // Create a new transaction with isRated set to true
      _transactions[index] = Transaction(
        id: transaction.id,
        date: transaction.date,
        items: transaction.items,
        status: transaction.status,
        duration: transaction.duration,
        isRated: true,
      );

      notifyListeners();
    }
  }
}
