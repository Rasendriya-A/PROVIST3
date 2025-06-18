import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/review_model.dart';
// import 'package:provis_tugas_3/services/cart_service.dart';
import 'package:provis_tugas_3/services/product_service.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';

class Detail extends StatefulWidget {
  final String productId;

  const Detail({super.key, required this.productId});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final ProductService _productService = ProductService();
  // final CartService _cartService = CartService();
  int quantity = 1;

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
                          errorBuilder:
                              (c, e, s) => Container(
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
                            // Harga dinamis tanpa .toInt()
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
                            onPressed:
                                () => setModalState(() {
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      // await _cartService.addToCart(
                      //   widget.productId,
                      //   productData,
                      //   quantity,
                      // );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${productData['name']} berhasil ditambahkan',
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: const Text(
                      'Masukkan Ke Keranjang',
                      style: TextStyle(color: Colors.white),
                    ),
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
                  errorBuilder:
                      (c, e, s) => Container(
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
                      // Harga dinamis tanpa .toInt()
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
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),

                // --- Bagian Review Dinamis ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Penilaian Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _productService.getProductReviewsStream(
                    widget.productId,
                  ),
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
          );
        },
      ),
    );
  }
}
