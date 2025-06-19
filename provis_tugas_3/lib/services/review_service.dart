import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provis_tugas_3/models/review_model.dart'; // Sesuaikan path jika perlu

class ReviewService {
  final CollectionReference _reviewCollection = FirebaseFirestore.instance
      .collection('reviews');

  final CollectionReference _productCollection = FirebaseFirestore.instance
      .collection('products');

  /// Menambahkan ulasan baru dan memperbarui rating produk menggunakan Transaction.
  Future<void> addReview(ReviewModel review) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // 1. Simpan dokumen ulasan yang baru
        final reviewDocRef = _reviewCollection.doc();
        // Menggunakan method toMap() dari ReviewModel yang sudah diperbarui
        transaction.set(reviewDocRef, review.toMap());

        // 2. Ambil semua ulasan untuk produk ini untuk menghitung ulang rating
        final querySnapshot =
            await _reviewCollection
                .where('productId', isEqualTo: review.productId)
                .get();

        // Mengubah semua dokumen menjadi List<ReviewModel>
        final reviews =
            querySnapshot.docs
                .map(
                  (doc) =>
                      ReviewModel.fromMap(doc.data() as Map<String, dynamic>),
                )
                .toList();

        // Menambahkan ulasan yang baru saja dibuat (secara lokal) agar ikut terhitung
        reviews.add(review);

        // 3. Hitung total rating dan rata-rata baru
        // Menggunakan 'int' untuk rating sesuai model
        double totalRating = reviews.fold(0, (sum, item) => sum + item.rating);
        double averageRating = totalRating / reviews.length;
        int reviewCount = reviews.length;

        // 4. Update dokumen produk dengan data agregat yang baru
        final productDocRef = _productCollection.doc(review.productId);
        transaction.update(productDocRef, {
          'averageRating': double.parse(averageRating.toStringAsFixed(1)),
          'reviewCount': reviewCount,
        });
      });
    } catch (e) {
      print('Gagal menambahkan ulasan: $e');
      throw Exception('Gagal menambahkan ulasan. Silakan coba lagi.');
    }
  }

  /// Mengambil semua ulasan untuk sebuah produk berdasarkan ID produk.
  Future<List<ReviewModel>> getReviewsByProductId(String productId) async {
    try {
      QuerySnapshot snapshot =
          await _reviewCollection
              .where('productId', isEqualTo: productId)
              .orderBy('createdAt', descending: true)
              .get();

      // Menggunakan factory constructor fromMap yang sudah diperbarui
      return snapshot.docs.map((doc) {
        return ReviewModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Gagal mengambil ulasan: $e');
      throw Exception('Gagal memuat ulasan.');
    }
  }
}
