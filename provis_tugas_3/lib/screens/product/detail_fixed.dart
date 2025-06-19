// lib/screens/product/detail_fixed.dart

import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/models/review_model.dart';
import 'package:provis_tugas_3/services/product_service.dart';
import 'package:provis_tugas_3/services/review_service.dart'; // PENTING: Import ReviewService

class DetailFixedPage extends StatefulWidget {
  final String productId;

  const DetailFixedPage({Key? key, required this.productId}) : super(key: key);

  @override
  _DetailFixedPageState createState() => _DetailFixedPageState();
}

class _DetailFixedPageState extends State<DetailFixedPage> {
  // Buat instance dari kedua service yang dibutuhkan
  final ProductService _productService = ProductService();
  final ReviewService _reviewService = ReviewService();

  late Future<ProductItemData> _productFuture;

  @override
  void initState() {
    super.initState();
    // Panggil method getProductById yang sudah diperbarui
    _productFuture = _productService.getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Produk')),
      body: FutureBuilder<ProductItemData>(
        future: _productFuture,
        builder: (context, snapshot) {
          // Bagian loading, error, dan data tidak ditemukan
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Gagal memuat produk: ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: Text("Produk tidak ditemukan."));
          }

          // Jika berhasil, 'snapshot.data' adalah objek ProductItemData
          final product = snapshot.data!;

          // Tampilan utama halaman detail
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Produk
                if (product.imageUrl.isNotEmpty)
                  Center(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      // Tambahkan error builder untuk menangani gambar yang gagal dimuat
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                SizedBox(height: 20),

                // Nama Produk
                Text(
                  product.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // Harga
                Text(
                  product.price,
                  style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                ),
                SizedBox(height: 16),

                // Deskripsi
                Text(
                  product.description ?? 'Tidak ada deskripsi.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 24),

                // Garis pemisah
                Divider(),
                SizedBox(height: 16),

                // Bagian Ulasan
                Text(
                  'Ulasan Pengguna',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Panggil widget untuk membangun daftar ulasan
                _buildReviewsSection(widget.productId),

                // Anda bisa menambahkan tombol untuk menambah ulasan di sini
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget terpisah untuk membangun bagian ulasan
  Widget _buildReviewsSection(String productId) {
    return StreamBuilder<List<ReviewModel>>(
      // Gunakan ReviewService untuk mendapatkan stream ulasan
      stream: _reviewService.getReviewsByProductId(productId).asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (snapshot.hasError) {
          return Text('Gagal memuat ulasan.');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Belum ada ulasan untuk produk ini.');
        }

        final reviews = snapshot.data!;

        return ListView.builder(
          shrinkWrap:
              true, // Agar ListView tidak mengambil semua ruang vertikal
          physics:
              NeverScrollableScrollPhysics(), // Agar tidak bisa di-scroll sendiri
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(review.userName),
                subtitle: Text(review.comment),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(review.rating.toString()),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
