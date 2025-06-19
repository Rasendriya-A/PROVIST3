import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/screens/auth/login_page.dart';
import 'package:provis_tugas_3/screens/product/detail_fixed.dart';
import 'package:provis_tugas_3/screens/transaction/transaction_page.dart';
import 'package:provis_tugas_3/services/cart_service.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'package:provis_tugas_3/utils/constants.dart';
import 'package:provis_tugas_3/widgets/category_item.dart';
import 'package:provis_tugas_3/screens/profile/pf_user/profile_screen.dart';
import 'package:provis_tugas_3/screens/product/browse.dart';
import 'package:provis_tugas_3/screens/cart/cart_page.dart';
import 'package:provis_tugas_3/services/product_service.dart';
import 'package:provis_tugas_3/services/product_setup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductSetup _productSetup = ProductSetup();
  final CartService _cartService = CartService();

  Widget _buildProductCard(ProductItemData product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailFixedPage(productId: product.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (Expanded agar gambar selalu proporsional)
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child:
                    product.imageUrl.isNotEmpty
                        ? Image.network(
                          product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                        : Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
              ),
            ),
            // Product Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: AppTextStyles.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Product Description
                  if (product.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        product.description!,
                        style: AppTextStyles.small.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 6),
                  // Price and Add Button
                  // ...existing code...
                  // Price and Add Button (vertical)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.price,
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () => _addToCart(product),
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            tooltip: 'Tambah ke keranjang',
                            padding: const EdgeInsets.all(
                              2,
                            ), // padding lebih kecil
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ), // ukuran minimum lebih kecil
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ...existing code...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(ProductItemData product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showLoginDialog();
      return;
    }

    try {
      await _cartService.addToCart(
        productId: product.id,
        productName: product.name,
        imageUrl: product.imageUrl,
        price: double.tryParse(product.price) ?? 0.0,
        quantity: 1,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added to cart!'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding to cart: $e')));
      }
    }
  }

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
                child: const Text('Login'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // 1. Ubah struktur body menjadi Column untuk memisahkan header dan konten
      body: Column(
        children: [
          // 2. Letakkan Header di sini, di luar SingleChildScrollView.
          // Header ini tidak akan bisa di-scroll dan tidak akan memiliki padding.
          Container(
            color: AppColors.primary,
            // SafeArea bisa ditambahkan di sini jika diperlukan agar tidak terlalu mepet ke atas
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Browse()),
                    );
                  },
                  child: Icon(Icons.search, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RentalCartPage(),
                      ),
                    );
                  },
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                ),
              ],
            ),
          ),

          // 3. Gunakan Expanded agar SingleChildScrollView mengisi sisa ruang layar
          Expanded(
            child: SingleChildScrollView(
              // 4. Terapkan padding HANYA di sini, untuk konten di bawah header
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mulai dari sini, semua widget adalah KONTEN yang memiliki padding
                  // App Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppConstants.appName, style: AppTextStyles.appTitle),
                      // Temporary setup button

                      // ElevatedButton.icon(
                      //   onPressed: () async {
                      //     try {
                      //       await _productSetup.addSampleProducts();
                      //       if (mounted) {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(
                      //             content: Text(
                      //               '✅ Produk berhasil ditambahkan!',
                      //             ),
                      //             backgroundColor: Colors.green,
                      //           ),
                      //         );
                      //       }
                      //     } catch (e) {
                      //       if (mounted) {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(
                      //             content: Text('❌ Error: $e'),
                      //             backgroundColor: Colors.red,
                      //           ),
                      //         );
                      //       }
                      //     }
                      //   },
                      //   icon: const Icon(Icons.add_box, size: 16),
                      //   label: const Text('Setup'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: AppColors.secondary,
                      //     foregroundColor: Colors.white,
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 8,
                      //       vertical: 4,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Carousel Section
                  SizedBox(
                    height: 180,
                    child: PageView(
                      children: const [
                        CarouselItem(
                          title: "Libur telah tiba!",
                          subtitle: "Siapin peralatan camping di YukKemah!",
                          imagePath: "assets/images/carousel/camp1.jpg",
                        ),
                        CarouselItem(
                          title: "Peralatan Berkualitas",
                          subtitle: "Sewa peralatan terpercaya",
                          imagePath: "assets/images/carousel/camp2.jpg",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Categories Section
                  Text("Kategori", style: AppTextStyles.header),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        Browse(initialCategory: "Tenda"),
                              ),
                            );
                          },
                          child: const CategoryItem(
                            label: "Tenda",
                            imageUrl: "assets/images/category/tenda.jpg",
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        Browse(initialCategory: "Sleeping Bag"),
                              ),
                            );
                          },
                          child: const CategoryItem(
                            label: "Sleeping Bag",
                            imageUrl: "assets/images/category/sleeping_bag.jpg",
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        Browse(initialCategory: "Pemandu"),
                              ),
                            );
                          },
                          child: const CategoryItem(
                            label: "Pemandu",
                            imageUrl: "assets/images/category/pemandu.jpg",
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        Browse(initialCategory: "Paket"),
                              ),
                            );
                          },
                          child: const CategoryItem(
                            label: "Paket Camping",
                            imageUrl: "assets/images/category/paket.jpg",
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Browse(initialCategory: "Tas"),
                              ),
                            );
                          },
                          child: const CategoryItem(
                            label: "Tas",
                            imageUrl: "assets/images/category/tas.jpg",
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        Browse(initialCategory: "Kitchenware"),
                              ),
                            );
                          },
                          child: const CategoryItem(
                            label: "Kitchenware",
                            imageUrl: "assets/images/category/kitchenware.webp",
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        Browse(initialCategory: "Sepatu"),
                              ),
                            );
                          },
                          child: const CategoryItem(
                            label: "Sepatu",
                            imageUrl: "assets/images/category/sepatu.webp",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recommended Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Produk dan Layanan", style: AppTextStyles.header),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Browse(),
                            ),
                          );
                        },
                        child: Text("Lihat Semua", style: AppTextStyles.link),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Product Grid
                  FutureBuilder<List<ProductItemData>>(
                    future: ProductService().getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada produk tersedia'),
                        );
                      }

                      final products = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: products.length > 4 ? 4 : products.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(products[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Browse"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Transaksi",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Browse()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransactionPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const CarouselItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
