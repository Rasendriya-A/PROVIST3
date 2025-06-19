import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provis_tugas_3/models/cart_item_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid; // Add item to cart
  Future<bool> addToCart({
    required String productId,
    required String productName,
    required String imageUrl,
    required double price,
    int quantity = 1,
  }) async {
    try {
      if (currentUserId == null) {
        print('Error: User not logged in');
        return false;
      }

      print('Adding to cart: $productName for user: $currentUserId');

      // Check if item already exists in cart
      final existingItem =
          await _firestore
              .collection('carts')
              .doc(currentUserId)
              .collection('items')
              .doc(productId)
              .get();

      if (existingItem.exists) {
        // Update quantity if item already exists
        final currentQuantity = existingItem.data()?['quantity'] ?? 0;
        await _firestore
            .collection('carts')
            .doc(currentUserId)
            .collection('items')
            .doc(productId)
            .update({
              'quantity': currentQuantity + quantity,
              // tambahkan baris berikut:
              'price': price,
            });
        print('Updated quantity for existing item');
      } else {
        // Add new item to cart
        await _firestore
            .collection('carts')
            .doc(currentUserId)
            .collection('items')
            .doc(productId)
            .set({
              'productId': productId,
              'name': productName,
              'imageUrl': imageUrl,
              'price': price,
              'quantity': quantity,
              'isSelected': true,
              'addedAt': FieldValue.serverTimestamp(),
            });
        print('Added new item to cart');
      }

      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  // Get cart items for current user
  Stream<List<RentalItem>> getCartItems() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('carts')
        .doc(currentUserId)
        .collection('items')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            // Safe price parsing
            double price = 0.0;
            try {
              final priceValue = data['price'];
              print(
                'DEBUG: priceValue = $priceValue (${priceValue.runtimeType})',
              );
              if (priceValue is String) {
                String cleanPrice = priceValue.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                price = double.parse(cleanPrice);
              } else if (priceValue is num) {
                price = priceValue.toDouble();
              }
            } catch (e) {
              price = 0.0;
            }

            return RentalItem(
              productId: doc.id, // Use document ID as productId
              name: data['name'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              price: price,
              quantity: data['quantity'] ?? 1,
              isSelected: data['isSelected'] ?? true,
            );
          }).toList();
        });
  }

  // Update item quantity
  Future<void> updateQuantity(String productId, int quantity) async {
    if (currentUserId == null) return;

    if (quantity <= 0) {
      // Remove item if quantity is 0 or less
      await removeFromCart(productId);
    } else {
      await _firestore
          .collection('carts')
          .doc(currentUserId)
          .collection('items')
          .doc(productId)
          .update({'quantity': quantity});
    }
  }

  // Update item selection
  Future<void> updateSelection(String productId, bool isSelected) async {
    if (currentUserId == null) return;

    await _firestore
        .collection('carts')
        .doc(currentUserId)
        .collection('items')
        .doc(productId)
        .update({'isSelected': isSelected});
  }

  // Remove item from cart
  Future<void> removeFromCart(String productId) async {
    if (currentUserId == null) return;

    await _firestore
        .collection('carts')
        .doc(currentUserId)
        .collection('items')
        .doc(productId)
        .delete();
  }

  // Clear cart
  Future<void> clearCart() async {
    if (currentUserId == null) return;

    final batch = _firestore.batch();
    final cartItems =
        await _firestore
            .collection('carts')
            .doc(currentUserId)
            .collection('items')
            .get();

    for (final doc in cartItems.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
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
    if (startDate == null || endDate == null) return 0.0;

    final selectedItems = items.where((item) => item.isSelected);
    final duration = calculateRentalDuration(startDate, endDate);

    if (duration <= 0) return 0.0;
    return selectedItems.fold(0.0, (total, item) {
      return total + (item.price * item.quantity * duration);
    });
  }

  // Get selected items
  List<RentalItem> getSelectedItems(List<RentalItem> items) {
    return items.where((item) => item.isSelected).toList();
  }

  // Get date picker theme
  ThemeData getDatePickerTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF4B6543),
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
    );
  }

  // Format number to currency
  String formatNumber(double number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(number);
  } // Check if user is authenticated

  bool get isUserAuthenticated => _auth.currentUser != null;
}
