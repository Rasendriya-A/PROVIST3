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
      price: "Rp${priceValue.toInt()} per hari",
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

      // Urutkan hasil
      if (sortBy != null && sortBy.isNotEmpty) {
        String fieldToSortBy = 'createdAt';
        bool descending = true;

        if (sortBy == 'harga_tertinggi') {
          fieldToSortBy = 'price_num'; // PASTIKAN ADA FIELD INI DI FIRESTORE
          descending = true;
        } else if (sortBy == 'harga_terendah') {
          fieldToSortBy = 'price_num'; // PASTIKAN ADA FIELD INI DI FIRESTORE
          descending = false;
        }

        query = query.orderBy(fieldToSortBy, descending: descending);
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
      }
      return [];
    }
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
}
