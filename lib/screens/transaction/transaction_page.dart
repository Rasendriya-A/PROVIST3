import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provis_tugas_3/models/transaction.dart' as model;
import 'package:provis_tugas_3/models/user_model.dart';
import 'package:provis_tugas_3/services/transaction_service.dart';
import 'package:provis_tugas_3/screens/auth/login_page.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provis_tugas_3/services/user_service.dart';
import 'package:provis_tugas_3/widgets/review_dialog.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TransactionService _transactionService = TransactionService();
  final UserService _userService = UserService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    final user = await _userService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  String formatNumber(double number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (!authSnapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Anda harus login untuk melihat transaksi',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return StreamBuilder<List<model.Transaction>>(
            stream: _transactionService.getUserTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 80, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}'),
                    ],
                  ),
                );
              }

              final transactions = snapshot.data ?? [];

              if (transactions.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada transaksi ditemukan.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return TransactionCard(
                    transaction: transaction,
                    formatNumber: formatNumber,
                    onReview: () {
                      if (_currentUser != null) {
                        showDialog(
                          context: context,
                          builder: (context) => ReviewDialog(
                            transaction: transaction,
                            user: _currentUser!,
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final model.Transaction transaction;
  final String Function(double) formatNumber;
  final VoidCallback onReview;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.formatNumber,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID: ${transaction.id.substring(0, 8)}...',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(transaction.createdAt),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 20),
            ...transaction.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${item.quantity} x ${formatNumber(item.price)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'Rp ${formatNumber(transaction.totalAmount)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status'),
                Text(
                  transaction.status.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(transaction.status),
                  ),
                ),
              ],
            ),
            if (transaction.status == model.TransactionStatus.completed) // Corrected status
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: onReview,
                    child: const Text('Leave a Review'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(model.TransactionStatus status) {
    switch (status) {
      case model.TransactionStatus.waitingApproval:
        return Colors.orange;
      case model.TransactionStatus.approved:
        return Colors.blue;
      case model.TransactionStatus.inProgress:
        return Colors.green;
      case model.TransactionStatus.completed:
        return Colors.purple;
      case model.TransactionStatus.damaged:
        return Colors.red;
    }
  }
}
