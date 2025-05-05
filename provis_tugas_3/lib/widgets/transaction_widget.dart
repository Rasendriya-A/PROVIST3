// widgets/status_filter_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provis_tugas_3/screens/transaction/services/transaction_service.dart';

// widgets/rating_dialog.dart
import 'package:provis_tugas_3/models/transaction.dart';

// widgets/transaction_card.dart
import 'package:intl/intl.dart';
// import '../screens/review_dialog.dart';

class StatusFilterBar extends StatelessWidget {
  const StatusFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<TransactionService>(context);
    final activeFilter = service.activeFilter;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            _FilterButton(
              label: 'Semua Status',
              isActive: activeFilter == 'Semua Status',
              onTap: () => service.setFilter('Semua Status'),
            ),
            const SizedBox(width: 8),
            _FilterButton(
              label: 'Disewa',
              isActive: activeFilter == 'Disewa',
              onTap: () => service.setFilter('Disewa'),
            ),
            const SizedBox(width: 8),
            _FilterButton(
              label: 'Selesai',
              isActive: activeFilter == 'Selesai',
              onTap: () => service.setFilter('Selesai'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterButton({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF3A5F3A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF3A5F3A)),
        ),
        child: Row(
          children: [
            if (isActive) Icon(Icons.check, size: 16, color: Colors.white),
            if (isActive) SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onRatingPressed;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.onRatingPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final dateFormat = DateFormat('dd MMMM yyyy', 'id');
    final formattedDate = dateFormat.format(transaction.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _StatusTag(status: transaction.status),
              ],
            ),
            const SizedBox(height: 12),
            ...transaction.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatter.format(item.price),
                            style: TextStyle(color: Colors.black87),
                          ),
                          if (index == 0 && transaction.items.length > 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "+${transaction.items.length - 1} produk lainnya",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text("${item.quantity}x"),
                  ],
                ),
              );
            }).toList(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total ${transaction.totalQuantity} produk: ${formatter.format(transaction.totalAmount)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (transaction.duration > 0)
                  Text(
                    "Durasi: ${transaction.duration} Hari",
                    style: TextStyle(color: Colors.black54),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text("Lihat Semua"),
                      Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ),
                if (transaction.status == 'Selesai' && !transaction.isRated)
                  ElevatedButton(
                    onPressed: onRatingPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade300),
                      elevation: 0,
                    ),
                    child: Text("Nilai"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String status;

  const _StatusTag({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        status == 'Disewa' ? Color(0xFFFCF5D9) : Color(0xFFDAEADC);

    final Color textColor =
        status == 'Disewa' ? Color(0xFFC9A413) : Color(0xFF3A5F3A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  final String transactionId;
  final Function(Review) onSubmit;

  const RatingDialog({
    Key? key,
    required this.transactionId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nilai',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating ? Colors.amber : Colors.grey,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tulis Ulasan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_rating > 0) {
                    final review = Review(
                      transactionId: widget.transactionId,
                      rating: _rating,
                      comment: _commentController.text,
                    );
                    widget.onSubmit(review);
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3A5F3A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Kirim',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
