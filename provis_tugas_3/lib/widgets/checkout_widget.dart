// lib/widgets/checkout_widgets.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provis_tugas_3/models/checkout_model.dart';
// import 'package:provis_tugas_3/utils/constants.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';

class RentalItemCard extends StatelessWidget {
  final RentalItemModel item;

  const RentalItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormat.format(item.price),
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          // Item quantity
          Text(
            "${item.quantity}x",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class DateSelector extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DateSelector({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    return Expanded(
      child: GestureDetector(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (picked != null && picked != selectedDate) {
            onDateChanged(picked);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(selectedDate),
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethodModel selectedMethod;
  final List<PaymentMethodModel> availableMethods;
  final Function(PaymentMethodModel) onMethodChanged;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedMethod,
    required this.availableMethods,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder:
              (context) => PaymentMethodBottomSheet(
                availableMethods: availableMethods,
                onMethodSelected: onMethodChanged,
              ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(selectedMethod.iconPath, height: 24),
                const SizedBox(width: 8),
                Text(
                  selectedMethod.name,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodBottomSheet extends StatelessWidget {
  final List<PaymentMethodModel> availableMethods;
  final Function(PaymentMethodModel) onMethodSelected;

  const PaymentMethodBottomSheet({
    Key? key,
    required this.availableMethods,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...availableMethods.map(
            (method) => ListTile(
              leading: Image.asset(
                method.iconPath,
                width: 40,
                height: 24,
                fit: BoxFit.contain,
              ),
              title: Text(method.name),
              onTap: () {
                onMethodSelected(method);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutSummaryCard extends StatelessWidget {
  final CheckoutSummaryModel summary;

  const CheckoutSummaryCard({Key? key, required this.summary})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Pembayaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal untuk Produk'),
              Text(currencyFormat.format(summary.subtotal)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Biaya Layanan'),
              Text(currencyFormat.format(summary.serviceFee)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Pembayaran'),
              Text(currencyFormat.format(summary.total)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                currencyFormat.format(summary.total),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const CheckoutButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  'Buat Pesanan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}
