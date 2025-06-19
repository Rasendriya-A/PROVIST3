import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/screens/transaction/transaction_page.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'package:provis_tugas_3/utils/constants.dart';
import 'package:provis_tugas_3/widgets/recommended_item.dart';
import 'package:provis_tugas_3/widgets/category_item.dart';
import 'package:provis_tugas_3/screens/profile/pf_user/profile_screen.dart';
import 'package:provis_tugas_3/screens/product/browse.dart';
import 'package:provis_tugas_3/screens/cart/cart_page.dart';
import 'package:provis_tugas_3/services/product_service.dart';
import 'package:provis_tugas_3/services/product_setup.dart';
import 'package:provis_tugas_3/widgets/auth_debug_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductSetup _productSetup = ProductSetup();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // 1. Ubah struktur body menjadi Column untuk memisahkan header dan konten
      body: Column(
        children: [
          // DEBUG: Auth Status Widget
          const AuthDebugWidget(),
          const SizedBox(height: 8),
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
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await _productSetup.addSampleProducts();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '✅ Produk berhasil ditambahkan!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('❌ Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.add_box, size: 16),
                        label: const Text('Setup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Carousel Section
                  SizedBox(
                    height: 180,
                    child: PageView(
                      children: const [
                        CarouselItem(
                          title: "Jelajahi Alam Bebas",
                          subtitle: "Temukan petualangan terbaik",
                          imagePath: "assets/images/carousel/camp1.jpg",
                        ),
                        CarouselItem(
                          title: "Peralatan Berkualitas",
                          subtitle: "Sewa equipment terpercaya",
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
                      children: const [
                        CategoryItem(
                          label: "Tenda",
                          imageUrl: "assets/images/category/tenda.jpg",
                        ),
                        SizedBox(width: 12),
                        CategoryItem(
                          label: "Sleeping Bag",
                          imageUrl: "assets/images/category/sleeping_bag.jpg",
                        ),
                        SizedBox(width: 12),
                        CategoryItem(
                          label: "Pemandu",
                          imageUrl: "assets/images/category/pemandu.jpg",
                        ),
                        SizedBox(width: 12),
                        CategoryItem(
                          label: "Paket Camping",
                          imageUrl: "assets/images/category/paket.jpg",
                        ),
                        SizedBox(width: 12),
                        CategoryItem(
                          label: "Tas",
                          imageUrl: "assets/images/category/tas.jpg",
                        ),
                        SizedBox(width: 12),
                        CategoryItem(
                          label: "Kitchenware",
                          imageUrl: "assets/images/category/kitchenware.webp",
                        ),
                        SizedBox(width: 12),
                        CategoryItem(
                          label: "Sepatu",
                          imageUrl: "assets/images/category/sepatu.webp",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recommended Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rekomendasi", style: AppTextStyles.header),
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
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: products.length > 4 ? 4 : products.length,
                        itemBuilder: (context, index) {
                          return RecommendedItem(product: products[index]);
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
