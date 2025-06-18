// lib/screens/order_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provis_tugas_3/models/checkout_model.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/screens/home/home_page.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final CheckoutSummaryModel orderSummary;

  const OrderConfirmationScreen({super.key, required this.orderSummary});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Pesanan Sukses',
          style: TextStyle(color: AppColors.textLight),
        ),
        automaticallyImplyLeading: false, // Disable back button
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            Icon(
              Icons.check_circle_outline,
              color: AppColors.primary,
              size: 80,
            ),

            const SizedBox(height: 16),

            Text(
              'Pesanan Berhasil!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Pesanan Anda telah berhasil dibuat.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Pesanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const Divider(height: 24),

                  // Order items
                  ...orderSummary.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              item.imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text('${item.quantity}x'),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 24),

                  // Rental period
                  Row(
                    children: [
                      Icon(Icons.date_range, size: 16, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(
                        '${dateFormat.format(orderSummary.rentalPeriod.startDate)} - ${dateFormat.format(orderSummary.rentalPeriod.endDate)}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 4),
                    child: Text(
                      '${orderSummary.rentalPeriod.durationInDays} hari',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Payment details
                  Row(
                    children: [
                      Icon(Icons.payment, size: 16, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(
                        orderSummary.paymentMethod.name,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const Divider(height: 24),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Text(
                        currencyFormat.format(orderSummary.total),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Instruksi pembayaran telah dikirim ke email Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                // Navigate back to home screen and clear all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Kembali ke Beranda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                // You can add functionality for viewing order details here
                // For example, navigate to a detailed order history screen
              },
              child: Text(
                'Lihat Detail Pesanan',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
