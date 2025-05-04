import 'package:flutter/material.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'package:provis_tugas_3/utils/constants.dart';
import 'package:provis_tugas_3/screens/product/detail.dart'; // Import Detail class

void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Urutkan', style: AppTextStyles.headerDark),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Sort options
              _buildSortOption('Paling Sesuai', isSelected: true),
              _buildSortOption('Ulasan', isSelected: false),
              _buildSortOption('Terbaru', isSelected: false),
              _buildSortOption('Harga', isSelected: false),
              _buildSortOption('Kondisi', isSelected: false),
              
              const SizedBox(height: 16), // Bottom padding
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildSortOption(String title, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title, 
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          isSelected 
            ? Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              )
            : Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                ),
              ),
        ],
      ),
    );
  }

// Added filter functionality
void _showFilterBottomSheet(BuildContext context) {
  // Filter state variables
  bool sleepingBagSelected = true;
  bool tasSelected = false;
  bool tendaSelected = false;
  bool baikSelected = false;
  bool layakPakaiSelected = true;
  bool baruSelected = false;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filter', style: AppTextStyles.headerDark),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  
                  // Category section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  
                  // Category options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildFilterOption('Tenda', tendaSelected, (value) {
                          setState(() {
                            tendaSelected = value;
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterOption('Sleeping Bag', sleepingBagSelected, (value) {
                          setState(() {
                            sleepingBagSelected = value;
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterOption('Tas Punggung', tasSelected, (value) {
                          setState(() {
                            tasSelected = value;
                          });
                        }),
                      ],
                    ),
                  ),
                  
                  // Condition section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: const Text('Kondisi', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  
                  // Condition options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildFilterOption('Baik', baikSelected, (value) {
                          setState(() {
                            baikSelected = value;
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterOption('Layak Pakai', layakPakaiSelected, (value) {
                          setState(() {
                            layakPakaiSelected = value;
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterOption('Baru', baruSelected, (value) {
                          setState(() {
                            baruSelected = value;
                          });
                        }),
                      ],
                    ),
                  ),
                  
                  // Price range section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: const Text('Harga', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  
                  // Price range options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text('Terendah'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text('Tertinggi'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Apply button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Terapkan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      );
    },
  );
}

Widget _buildFilterOption(String title, bool isSelected, Function(bool) onChanged) {
  return InkWell(
    onTap: () {
      onChanged(!isSelected);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(Icons.check, size: 16, color: Colors.white),
            ),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textDark,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}

class Browse extends StatelessWidget {
  const Browse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Tenda',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('Tenda', isSelected: false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Terlaris', isSelected: true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Sleeping Bag', isSelected: false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Terbaru', isSelected: false),
                ],
              ),
            ),
          ),
          
          // Sort Options
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _showSortBottomSheet(context);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.swap_vert, size: 20),
                      SizedBox(width: 4),
                      Text('Paling Sesuai', style: AppTextStyles.button),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.grid_view),
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
              ],
            ),
          ),
          
          // Product Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildProductFromData(
                    context,
                    ProductItemData(
                      name: 'Tenda',
                      price: 'Rp50.000 per hari',
                      imageUrl: 'assets/images/items/tenda_1.jpg'
                    ),
                    4.7,
                    1
                  ),
                  _buildProductFromData(
                    context,
                    ProductItemData(
                      name: 'Tenda',
                      price: 'Rp85.000 per hari',
                      imageUrl: 'assets/images/items/tenda_2.jpg'
                    ),
                    4.6,
                    2
                  ),
                  _buildProductFromData(
                    context,
                    ProductItemData(
                      name: 'Tenda',
                      price: 'Rp60.000 per hari',
                      imageUrl: 'assets/images/items/tenda_3.jpg'
                    ),
                    4.9,
                    3
                  ),
                  _buildProductFromData(
                    context,
                    ProductItemData(
                      name: 'Tenda',
                      price: 'Rp100.000 per hari',
                      imageUrl: 'assets/images/items/tenda_4.jpg'
                    ),
                    4.7,
                    4
                  ),
                  _buildProductFromData(
                    context,
                    ProductItemData(
                      name: 'Tenda',
                      price: 'Rp200.000 per hari',
                      imageUrl: 'assets/images/items/tenda_5.jpg'
                    ),
                    4.5,
                    5
                  ),
                  _buildProductFromData(
                    context,
                    ProductItemData(
                      name: 'Tenda',
                      price: 'Rp120.000 per hari',
                      imageUrl: 'assets/images/items/tenda_6.jpg'
                    ),
                    4.6,
                    6
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.check, size: 16, color: Colors.white),
            ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textDark,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductFromData(BuildContext context, ProductItemData product, double rating, int productId) {
    return InkWell(
      onTap: () {
        // Navigate to existing Detail page with product data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Detail(
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius / 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.defaultBorderRadius / 2)
              ),
              child: Image.asset(
                product.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.label,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.price,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: AppTextStyles.small,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}