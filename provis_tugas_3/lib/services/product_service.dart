// lib/services/product_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provis_tugas_3/models/product_item_data.dart'; // Sesuaikan path jika perlu

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _productCollection = FirebaseFirestore.instance
      .collection('products');

  // Helper method internal untuk mengubah data Firestore menjadi objek ProductItemData
  ProductItemData _mapToProductItemData(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    num priceValue = 0;
    if (data['price'] is String) {
      priceValue = num.tryParse(data['price']) ?? 0;
    } else if (data['price'] is num) {
      priceValue = data['price'];
    }

    return ProductItemData(
      id: doc.id,
      name: data['name'] ?? 'No Name',
      price: "${priceValue.toInt()}",
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] as String?,
      // Anda bisa tambahkan properti lain di sini jika model Anda memilikinya
      // averageRating: (data['averageRating'] as num? ?? 0).toDouble(),
    );
  }

  /// Mengambil semua produk, dengan opsi filter dan urutan.
  Future<List<ProductItemData>> getProducts({
    String? category,
    String? sortBy,
  }) async {
    try {
      Query query = _productCollection;

      // Filter berdasarkan kategori
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      // Urutkan hasil berdasarkan field 'price' yang ada di Firestore
      if (sortBy != null && sortBy.isNotEmpty) {
        if (sortBy == 'harga_tertinggi') {
          // Sort by price descending (highest first)
          query = query.orderBy('price', descending: true);
        } else if (sortBy == 'harga_terendah') {
          // Sort by price ascending (lowest first)
          query = query.orderBy('price', descending: false);
        } else {
          // Default sort by creation date
          query = query.orderBy('createdAt', descending: true);
        }
      }

      final snapshot = await query.get();
      final products = snapshot.docs.map(_mapToProductItemData).toList();
      return products;
    } catch (e) {
      print("Error getting products: $e");
      if (e.toString().contains('requires an index')) {
        print(
          "PENTING: Firestore membutuhkan index untuk query ini. Silakan buat di Firebase console.",
        );
        // Fallback: Get products without sorting and apply client-side sorting
        return _getProductsWithClientSideSorting(
          category: category,
          sortBy: sortBy,
        );
      }
      return [];
    }
  }

  /// Fallback method untuk sorting di sisi client jika Firestore index tidak tersedia
  Future<List<ProductItemData>> _getProductsWithClientSideSorting({
    String? category,
    String? sortBy,
  }) async {
    try {
      Query query = _productCollection;

      // Filter berdasarkan kategori saja
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.get();
      List<ProductItemData> products =
          snapshot.docs.map(_mapToProductItemData).toList();

      // Apply client-side sorting
      if (sortBy != null && sortBy.isNotEmpty) {
        if (sortBy == 'harga_tertinggi' || sortBy == 'harga_terendah') {
          products.sort((a, b) {
            // Extract numeric value from price
            double priceA = _extractNumericPrice(a.price);
            double priceB = _extractNumericPrice(b.price);

            if (sortBy == 'harga_tertinggi') {
              return priceB.compareTo(priceA); // Descending
            } else {
              return priceA.compareTo(priceB); // Ascending
            }
          });
        }
      }

      return products;
    } catch (e) {
      print("Error in client-side sorting: $e");
      return [];
    }
  }

  /// Helper method untuk mengekstrak nilai numerik dari price string
  double _extractNumericPrice(String priceString) {
    // Remove "Rp" and " per hari" and any formatting
    String numericOnly = priceString
        .replaceAll('Rp', '')
        .replaceAll(' per hari', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll(' ', '');

    return double.tryParse(numericOnly) ?? 0.0;
  }

  /// Mengambil satu produk berdasarkan ID-nya.
  Future<ProductItemData> getProductById(String productId) async {
    final doc = await _productCollection.doc(productId).get();
    return _mapToProductItemData(doc);
  }

  /// Mencari produk berdasarkan nama.
  Future<List<ProductItemData>> searchProducts(String searchQuery) async {
    if (searchQuery.isEmpty) {
      return [];
    }

    try {
      final snapshot =
          await _productCollection
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
              .get();

      return snapshot.docs.map(_mapToProductItemData).toList();
    } catch (e) {
      print("Error searching products: $e");
      return [];
    }
  }

  /// === FUNGSI YANG DIPERBAIKI ===
  /// Mengambil daftar semua kategori unik dari produk.
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _productCollection.get();

      // Mengambil semua nilai kategori dan memfilternya
      final categoryList =
          snapshot.docs
              .map(
                (doc) =>
                    (doc.data() as Map<String, dynamic>)['category'] as String?,
              )
              .whereType<
                String
              >() // Hanya ambil nilai yang bertipe String (membuang null)
              .toSet() // Jadikan unik
              .toList(); // Ubah kembali ke List

      // Sekarang 'categoryList' dijamin bertipe List<String>
      return ['All', ...categoryList];
    } catch (e) {
      print("Error getting categories: $e");
      return ['All'];
    }
  }

  /// Mengambil 5 produk terakhir berdasarkan field 'createdAt'.
  Future<List<ProductItemData>> getLatestProducts({int limit = 5}) async {
    try {
      final snapshot =
          await _productCollection
              .orderBy(
                'createdAt',
                descending: true,
              ) // Urutkan dari yang terbaru
              .limit(limit) // Batasi jumlahnya
              .get();

      return snapshot.docs.map(_mapToProductItemData).toList();
    } catch (e) {
      print("Error getting latest products: $e");
      if (e.toString().contains('requires an index')) {
        print(
          "PENTING: Firestore membutuhkan index untuk query ini. Silakan buat di Firebase console.",
        );
      }
      return [];
    }
  }
}
