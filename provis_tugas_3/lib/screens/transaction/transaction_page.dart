// screens/transactions_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provis_tugas_3/models/transaction.dart';
import 'package:provis_tugas_3/screens/transaction/services/transaction_service.dart';
import 'package:provis_tugas_3/widgets/transaction_widget.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _loadTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    final service = Provider.of<TransactionService>(context, listen: false);
    await service.fetchTransactions();
    setState(() {
      _isLoading = false;
    });
  }

  void _showRatingDialog(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder:
          (context) => RatingDialog(
            transactionId: transaction.id,
            onSubmit: (Review review) {
              final service = Provider.of<TransactionService>(
                context,
                listen: false,
              );
              service.submitReview(review);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi'),
        backgroundColor: Color(0xFF3A5F3A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Consumer<TransactionService>(
                builder: (context, service, child) {
                  final transactions = service.transactions;

                  return Column(
                    children: [
                      StatusFilterBar(),
                      Expanded(
                        child:
                            transactions.isEmpty
                                ? Center(child: Text('Tidak ada transaksi'))
                                : ListView.builder(
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction = transactions[index];
                                    return TransactionCard(
                                      transaction: transaction,
                                      onRatingPressed:
                                          () => _showRatingDialog(
                                            context,
                                            transaction,
                                          ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  );
                },
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Color(0xFF3A5F3A),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
