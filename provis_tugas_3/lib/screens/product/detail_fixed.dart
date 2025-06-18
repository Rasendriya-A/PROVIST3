import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/review_model.dart';
import 'package:provis_tugas_3/services/cart_service.dart';
import 'package:provis_tugas_3/services/product_service.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/screens/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailFixed extends StatefulWidget {
  final String productId;

  const DetailFixed({super.key, required this.productId});

  @override
  State<DetailFixed> createState() => _DetailFixedState();
}

class _DetailFixedState extends State<DetailFixed> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  int quantity = 1;

  // Method to show login dialog
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text(
          'Anda harus login terlebih dahulu untuk menambahkan produk ke keranjang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan bottom sheet "Tambah ke Keranjang"
  void _showCartBottomSheet(Map<String, dynamic> productData) {
    setState(() => quantity = 1); // Reset kuantitas

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambah ke Keranjang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          productData['imageUrl'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productData['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rp${productData['price']} per hari",
                              style: const TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jumlah', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => setModalState(() {
                              if (quantity > 1) quantity--;
                            }),
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => setModalState(() => quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, authSnapshot) {
                      final user = authSnapshot.data;
                      
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                        ),                        onPressed: () async {
                          // Check if user is authenticated using stream data
                          if (user == null) {
                            Navigator.pop(context); // Close bottom sheet first
                            _showLoginDialog();
                            return;
                          }

                          // Add to cart
                          double price = 0.0;
                          try {
                            final priceValue = productData['price'];
                            if (priceValue is String) {
                              String cleanPrice = priceValue.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              );
                              price = double.parse(cleanPrice);
                            } else if (priceValue is num) {
                              price = priceValue.toDouble();
                            } else {
                              price = 700000;
                            }
                          } catch (e) {
                            price = 700000;                          }

                          print('Adding product: ${productData['name']} with price: $price');

                          final success = await _cartService.addToCart(
                            productId: widget.productId,
                            productName: productData['name'],
                            imageUrl: productData['imageUrl'],
                            price: price,
                            quantity: quantity,
                          );

                          Navigator.pop(context);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${productData['name']} berhasil ditambahkan ke keranjang',
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gagal menambahkan ke keranjang'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Masukkan Ke Keranjang',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Detail Produk',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _productService.getProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Produk tidak ditemukan."));
          }
          var productData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  productData['imageUrl'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rp${productData['price']} per hari",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () => _showCartBottomSheet(productData),
                        child: const Text(
                          'Masukkan Ke Keranjang',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        productData['description'] ?? 'Tidak ada deskripsi.',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Ulasan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('reviews')
                            .where('productId', isEqualTo: widget.productId)
                            .get(),
                        builder: (context, reviewSnapshot) {
                          if (reviewSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (!reviewSnapshot.hasData ||
                              reviewSnapshot.data!.docs.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Belum ada ulasan untuk produk ini."),
                            );
                          }
                          final reviews = reviewSnapshot.data!.docs;
                          return ListView.builder(
                            itemCount: reviews.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final review = ReviewModel.fromFirestore(
                                reviews[index],
                              );
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (starIndex) => Icon(
                                            starIndex < review.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(review.comment),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
