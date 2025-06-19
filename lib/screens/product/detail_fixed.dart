import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/review_model.dart';
import 'package:provis_tugas_3/services/cart_service.dart';
import 'package:provis_tugas_3/services/product_service.dart';
import 'package:provis_tugas_3/services/review_service.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/screens/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provis_tugas_3/widgets/review_card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailFixed extends StatefulWidget {
  final String productId;

  const DetailFixed({super.key, required this.productId});

  @override
  State<DetailFixed> createState() => _DetailFixedState();
}

class _DetailFixedState extends State<DetailFixed> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  final ReviewService _reviewService = ReviewService();
  int quantity = 1;
  late Future<DocumentSnapshot> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _productService.getProductById(widget.productId);
  }

  // Method to show login dialog
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
    final int stock = (productData['stock'] as num?)?.toInt() ?? 0;

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
                          cacheWidth:
                              160, // double the display size for quality
                          cacheHeight: 160,
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
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (quantity > 1) {
                                setModalState(() => quantity--);
                              }
                            },
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              if (quantity < stock) {
                                setModalState(() => quantity++);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Jumlah melebihi stok yang tersedia.',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          stock > 0
                              ? () async {
                                final User? user =
                                    FirebaseAuth.instance.currentUser;
                                if (user == null) {
                                  _showLoginDialog();
                                  return;
                                }

                                try {
                                  final dynamic priceData =
                                      productData['price'];
                                  double price = 0.0;

                                  if (priceData is String) {
                                    price =
                                        double.tryParse(
                                          priceData.replaceAll(
                                            RegExp(r'[^0-9.]'),
                                            '',
                                          ),
                                        ) ??
                                        0.0;
                                  } else if (priceData is num) {
                                    price = priceData.toDouble();
                                  }

                                  await _cartService.addToCart(
                                    productId: widget.productId,
                                    productName:
                                        productData['name'] ?? 'No Name',
                                    imageUrl: productData['imageUrl'] ?? '',
                                    price: price,
                                    quantity: quantity,
                                  );
                                  if (mounted) {
                                    Navigator.pop(
                                      context,
                                    ); // Close bottom sheet
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          '✅ Berhasil ditambahkan ke keranjang!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e, s) {
                                  print('Error adding to cart: $e');
                                  print('Stack trace: $s');
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '❌ Gagal menambahkan: $e',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Masukkan Ke Keranjang',
                        style: TextStyle(color: Colors.white),
                      ),
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
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Produk tidak ditemukan."));
          }
          var productData = snapshot.data!.data() as Map<String, dynamic>;

          return CustomScrollView(
            slivers: [
              // Bagian Gambar Produk
              SliverToBoxAdapter(
                child: Hero(
                  tag: 'product-image-${widget.productId}',
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(productData['imageUrl'] ?? ''),
                        fit: BoxFit.cover,
                        onError: (e, s) => print('Image load error: $e'),
                      ),
                    ),
                    child: Image.network(
                      productData['imageUrl'] ?? '',
                      fit: BoxFit.cover,
                      cacheHeight: 600, // double the display size for quality
                      errorBuilder:
                          (c, e, s) => const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                    ),
                  ),
                ),
              ),

              // Bagian Detail Produk
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData['name'] ?? 'Nama Produk Tidak Tersedia',
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
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stok: ${(productData['stock'] as num?)?.toInt() ?? 0}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        productData['description'] ??
                            'Deskripsi tidak tersedia.',
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      const Divider(thickness: 1),
                      const SizedBox(height: 16),
                      const Text(
                        'Ulasan & Rating',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating:
                                (productData['averageRating'] as num?)
                                    ?.toDouble() ??
                                0.0,
                            itemBuilder:
                                (context, index) =>
                                    const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 24.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(productData['averageRating'] as num?)?.toDouble().toStringAsFixed(1) ?? '0.0'} (${productData['reviewCount'] ?? 0} ulasan)',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              StreamBuilder<List<Review>>(
                stream: _reviewService.getReviewsForProduct(widget.productId),
                builder: (context, reviewSnapshot) {
                  if (reviewSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (reviewSnapshot.hasError) {
                    print("Error loading reviews: ${reviewSnapshot.error}");
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('Gagal memuat ulasan.')),
                    );
                  }
                  if (!reviewSnapshot.hasData || reviewSnapshot.data!.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text('Belum ada ulasan untuk produk ini.'),
                        ),
                      ),
                    );
                  }
                  final reviews = reviewSnapshot.data!;
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ReviewCard(review: reviews[index]);
                      }, childCount: reviews.length),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<DocumentSnapshot>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const SizedBox.shrink();
          }
          var productData = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showCartBottomSheet(productData),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tambah Ke Keranjang',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
