// lib/screens/product/detail_fixed.dart

import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/models/review_model.dart';
import 'package:provis_tugas_3/services/product_service.dart';
import 'package:provis_tugas_3/services/review_service.dart';
import 'package:provis_tugas_3/services/cart_service.dart'; // Import CartService

class DetailFixedPage extends StatefulWidget {
  final String productId;

  const DetailFixedPage({Key? key, required this.productId}) : super(key: key);

  @override
  _DetailFixedPageState createState() => _DetailFixedPageState();
}

class _DetailFixedPageState extends State<DetailFixedPage> {
  // Buat instance dari semua service yang dibutuhkan
  final ProductService _productService = ProductService();
  final ReviewService _reviewService = ReviewService();
  final CartService _cartService = CartService(); // Tambahkan CartService

  late Future<ProductItemData> _productFuture;
  bool _isAddingToCart = false; // Loading state untuk tombol Add to Cart

  @override
  void initState() {
    super.initState();
    // Panggil method getProductById yang sudah diperbarui
    _productFuture = _productService.getProductById(widget.productId);
  }

  // Method untuk menambahkan produk ke cart
  Future<void> _addToCart(ProductItemData product) async {
    // Cek apakah user sudah login
    if (!_cartService.isUserAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Silakan login terlebih dahulu untuk menambahkan ke keranjang',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isAddingToCart = true;
    });

    try {
      // Parse harga dari string ke double
      double price = 0.0;
      try {
        String cleanPrice = product.price.replaceAll(RegExp(r'[^0-9]'), '');
        price = double.parse(cleanPrice);
      } catch (e) {
        print('Error parsing price: $e');
        price = 0.0;
      }

      // Panggil method addToCart dari CartService
      bool success = await _cartService.addToCart(
        productId: widget.productId,
        productName: product.name,
        imageUrl: product.imageUrl,
        price: price,
        quantity: 1,
      );

      if (success) {
        // Tampilkan snackbar sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} berhasil ditambahkan ke keranjang'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Lihat Keranjang',
              textColor: Colors.white,
              onPressed: () {
                // Navigasi ke halaman cart (sesuaikan dengan routing app Anda)
                // Navigator.pushNamed(context, '/cart');
              },
            ),
          ),
        );
      } else {
        // Tampilkan snackbar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan produk ke keranjang'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat menambahkan ke keranjang'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
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
          return Column(
            children: [
              // Konten utama
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Produk
                      if (product.imageUrl.isNotEmpty)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrl,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              // Tambahkan error builder untuk menangani gambar yang gagal dimuat
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    height: 250,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 100,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20),

                      // Nama Produk
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Harga
                      Text(
                        product.price,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Deskripsi
                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Panggil widget untuk membangun daftar ulasan
                      _buildReviewsSection(widget.productId),
                    ],
                  ),
                ),
              ),

              // Bottom section dengan tombol Add to Cart
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          _isAddingToCart ? null : () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4B6543),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child:
                          _isAddingToCart
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text('Menambahkan...'),
                                ],
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart_outlined),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tambah ke Keranjang',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ),
            ],
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
