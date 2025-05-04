import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'package:provis_tugas_3/utils/constants.dart';
import 'package:provis_tugas_3/widgets/recommended_item.dart';
import 'package:provis_tugas_3/widgets/category_item.dart';
import 'package:provis_tugas_3/widgets/horizontal_product_list.dart';
import 'package:provis_tugas_3/screens/profile/profile_page.dart';
import 'package:provis_tugas_3/screens/product/browse.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Browse()),
                      );
                    },
                    child: Icon(Icons.search, color: AppColors.textLight),
                  ),
                  Icon(Icons.shopping_cart, color: AppColors.textLight),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // App Title
            Text(AppConstants.appName, style: AppTextStyles.appTitle),
            const SizedBox(height: 16),

            // Carousel
            SizedBox(
              height: 180,
              child: PageView(
                children: [
                  _carouselImage('assets/images/carousel/camp1.jpg'),
                  _carouselImage('assets/images/carousel/camp2.jpg'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Kategori
            Text('Kategori', style: AppTextStyles.header),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryItem(label: 'Tenda', imageUrl: 'assets/images/category/tenda.jpg'),
                  CategoryItem(label: 'Sleeping Bag', imageUrl: 'assets/images/category/sleeping_bag.jpg'),
                  CategoryItem(label: 'Paket', imageUrl: 'assets/images/category/paket.jpg'),
                  CategoryItem(label: 'Tas', imageUrl: 'assets/images/category/tas.jpg'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Paling Banyak Disewa
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paling Banyak Disewa!', 
                    style: AppTextStyles.headerLight
                  ),
                  const SizedBox(height: 12),
                  HorizontalProductList(
                    products: [
                      ProductItemData(
                        name: 'Tenda 1',
                        price: 'Rp50.000 per hari',
                        imageUrl: 'assets/images/items/tenda_1.jpg',
                      ),
                      ProductItemData(
                        name: 'Tenda 2',
                        price: 'Rp85.000 per hari',
                        imageUrl: 'assets/images/items/tenda_2.jpg',
                      ),
                      ProductItemData(
                        name: 'Tenda 3',
                        price: 'Rp60.000 per hari',
                        imageUrl: 'assets/images/items/tenda_3.jpg',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Alat-Alat Terbaru
            Text('Alat-Alat Terbaru', style: AppTextStyles.header),
            const SizedBox(height: 12),
            HorizontalProductList(
              products: [
                ProductItemData(
                  name: 'Kitchenware',
                  price: 'Rp30.000 per hari',
                  imageUrl: 'assets/images/items/kitchenware_1.jpg',
                ),
                ProductItemData(
                  name: 'Sepatu',
                  price: 'Rp40.000 per hari',
                  imageUrl: 'assets/images/items/sepatu_1.jpg',
                ),
                ProductItemData(
                  name: 'Tas',
                  price: 'Rp20.000 per hari',
                  imageUrl: 'assets/images/items/tas_1.jpg',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Rekomendasi
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Rekomendasi', 
                    style: AppTextStyles.headerLight,
                  ),
                  SizedBox(height: 12),
                  RecommendedItem(
                    imageUrl: 'assets/images/items/tenda_4.jpg',
                    title: 'Tenda',
                    description: 'Cocok untuk pendakian, camping keluarga, atau glamping ringan.',
                    price: 'Rp100.000 per hari',
                  ),
                  RecommendedItem(
                    imageUrl: 'assets/images/items/tas_2.jpg',
                    title: 'Tas',
                    description: 'Tas outdoor multifungsi untuk membawa perlengkapan kemah Anda.',
                    price: 'Rp200.000 per hari',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        onTap: (index) {
          // Aksi navigasi berdasarkan index yang dipilih
          if (index == 2) { // Jika tombol Profile ditekan (index 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  static Widget _carouselImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
