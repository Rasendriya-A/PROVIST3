// lib/services/checkout_service.dart

import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/checkout_model.dart';

class CheckoutService {
  Future<bool> processCheckout(CheckoutSummaryModel checkout) async {
    // Simulate API call with a delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, this would make API calls to process payment and rental
    // For the demo, we just return true to simulate success
    return true;
  }

  Future<List<RentalItemModel>> getCartItems() async {
    // This would normally fetch cart items from an API or local database
    // For demo purposes, we return mock data
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      RentalItemModel(
        name: 'Tenda',
        imageUrl: 'assets/images/items/tenda_2.jpg',
        price: 700000,
        quantity: 1,
      ),
      RentalItemModel(
        name: 'Tenda',
        imageUrl: 'assets/images/items/tenda_3.jpg',
        price: 700000,
        quantity: 1,
      ),
    ];
  }

  Future<List<PaymentMethodModel>> getAvailablePaymentMethods() async {
    // This would normally fetch payment methods from an API
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      PaymentMethodModel(
        name: 'Transfer BCA',
        iconPath: 'assets/images/items/bca_logo.png',
      ),
      PaymentMethodModel(
        name: 'Transfer Mandiri',
        iconPath: 'assets/images/items/mandiri_logo.png',
      ),
      // Add more payment methods as needed
    ];
  }

  double calculateServiceFee(double subtotal) {
    // Simple fixed service fee for demo purposes
    return 10000;
  }
}
