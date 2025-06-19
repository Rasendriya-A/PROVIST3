// lib/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provis_tugas_3/models/product_item_data.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mengambil semua produk dari collection 'products'
  Future<List<ProductItemData>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('products').get();

      print(
        "Jumlah dokumen yang ditemukan di Firestore: ${snapshot.docs.length}",
      );

      List<ProductItemData> products =
          snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            // --- LOGIKA BARU UNTUK HARGA YANG LEBIH AMAN ---
            num priceValue =
                0; // Siapkan variabel untuk menampung harga sebagai angka

            if (data['price'] is String) {
              // Jika datanya adalah String, coba parse menjadi angka
              priceValue = num.tryParse(data['price']) ?? 0;
            } else if (data['price'] is num) {
              // Jika datanya sudah angka, langsung gunakan
              priceValue = data['price'];
            }

            // Modifikasi ProductItemData untuk menyertakan ID
            return ProductItemData(
              id: doc.id, // Ambil ID dokumen, ini PENTING untuk halaman detail
              name: data['name'] ?? 'No Name',
              price: "Rp${priceValue.toInt()} per hari",
              imageUrl: data['imageUrl'] ?? '',
              description: data['description'] as String?,
              stock: (data['stock'] is num) ? (data['stock'] as num).toInt() : 0,
              averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
              reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
            );
          }).toList();

      return products;
    } catch (e) {
      print("Error getting products: $e");
      return [];
    }
  }

  // Mengambil satu produk berdasarkan ID-nya
  Future<DocumentSnapshot> getProductById(String productId) {
    return _db.collection('products').doc(productId).get();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addProductReview(
    String productId,
    int rating,
    String comment,
  ) async {
    final User? user = _auth.currentUser;
    if (user == null) return; // Hanya user yang login yang bisa memberi review

    await _db.collection('products').doc(productId).collection('reviews').add({
      'userId': user.uid,
      'userName':
          user.displayName ?? user.email ?? 'Anonymous', // Ambil nama user
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.now(),
    });

    // (Opsional Lanjutan): Anda bisa menambahkan logika untuk update rata-rata rating di dokumen produk utama
  }

  Stream<QuerySnapshot> getProductReviewsStream(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy(
          'createdAt',
          descending: true,
        ) // Tampilkan yang terbaru di atas
        .snapshots();
  }
}
