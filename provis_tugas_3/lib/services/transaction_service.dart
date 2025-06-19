import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provis_tugas_3/models/transaction.dart' as model;
import 'package:provis_tugas_3/models/cart_item_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Create transaction from cart items
  Future<String?> createTransaction({
    required List<RentalItem> items,
    required DateTime startDate,
    required DateTime endDate,
    required double totalAmount,
    required String paymentMethod,
    String? notes,
  }) async {
    try {
      print('Creating transaction...');

      if (currentUserId == null) {
        print('Error: User not logged in');
        throw Exception('User not logged in');
      }

      print('Current user ID: $currentUserId');
      print('Items count: ${items.length}');

      // Convert cart items to transaction items
      final transactionItems =
          items
              .map(
                (item) => model.TransactionItem(
                  productId: item.productId ?? '',
                  name: item.name,
                  imageUrl: item.imageUrl,
                  price: item.price,
                  quantity: item.quantity,
                ),
              )
              .toList();

      print('Transaction items converted: ${transactionItems.length}');

      // Create transaction
      final transaction = model.Transaction(
        id: '', // Will be set by Firestore
        userId: currentUserId!,
        createdAt: DateTime.now(),
        startDate: startDate,
        endDate: endDate,
        items: transactionItems,
        status: model.TransactionStatus.waitingApproval,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        notes: notes,
      );

      print('Transaction object created, saving to Firestore...');

      // Save to Firestore
      final docRef = await _firestore
          .collection('transactions')
          .add(transaction.toMap());

      // Update product stock
      await updateProductStock(transactionItems);

      print('Transaction saved successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating transaction: $e');
      return null;
    }
  }

  // Update product stock
  Future<void> updateProductStock(List<model.TransactionItem> items) async {
    try {
      print('Updating product stock...');
      final batch = _firestore.batch();

      for (final item in items) {
        final productRef = _firestore.collection('products').doc(item.productId);
        batch.update(productRef, {'stock': FieldValue.increment(-item.quantity)});
      }

      await batch.commit();
      print('Product stock updated successfully.');
    } catch (e) {
      print('Error updating product stock: $e');
      // Handle or rethrow the error as needed
    }
  }

  // Get user transactions
  Stream<List<model.Transaction>> getUserTransactions() {
    if (currentUserId == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          // Sort in memory instead of Firestore to avoid index requirement
          final transactions =
              snapshot.docs.map((doc) {
                return model.Transaction.fromMap(doc.id, doc.data());
              }).toList();

          // Sort by createdAt in descending order
          transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return transactions;
        });
  }

  // Update transaction status
  Future<void> updateTransactionStatus(
    String transactionId,
    model.TransactionStatus status,
  ) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).update({
        'status': status.index,
      });
    } catch (e) {
      print('Error updating transaction status: $e');
    }
  }

  // Get transaction by ID
  Future<model.Transaction?> getTransactionById(String transactionId) async {
    try {
      final doc =
          await _firestore.collection('transactions').doc(transactionId).get();

      if (doc.exists) {
        return model.Transaction.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting transaction: $e');
      return null;
    }
  }

  // Add rating to transaction
  Future<bool> rateTransaction(
    String transactionId,
    int rating,
    String comment,
  ) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).update({
        'isRated': true,
      });

      // Also save the rating separately if needed
      await _firestore.collection('ratings').add({
        'transactionId': transactionId,
        'userId': currentUserId,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error rating transaction: $e');
      return false;
    }
  }
}
