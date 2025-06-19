import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provis_tugas_3/models/review_model.dart';
import 'package:provis_tugas_3/models/transaction.dart' as model;
import 'package:provis_tugas_3/models/user_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a review for each item in a transaction
  Future<void> addReview({
    required model.Transaction transaction,
    required double rating,
    required String? comment,
    required UserModel user,
  }) async {
    try {
      final batch = _firestore.batch();
      final reviewCollection = _firestore.collection('reviews');

      for (final item in transaction.items) {
        final reviewDoc = reviewCollection.doc();
        final newReview = Review(
          id: reviewDoc.id,
          userId: user.uid, // Corrected to use uid
          userName: user.name, // Corrected to use name
          userImageUrl: user.photoURL, // Corrected to use photoURL
          productId: item.productId,
          rating: rating,
          comment: comment,
          createdAt: Timestamp.now(),
        );
        batch.set(reviewDoc, newReview.toMap());
      }

      await batch.commit();

      // After adding reviews, update the average rating for each product
      for (final item in transaction.items) {
        await _updateAverageRating(item.productId);
      }
    } catch (e) {
      print('Error adding review: $e');
      rethrow;
    }
  }

  // Get all reviews for a specific product
  Stream<List<Review>> getReviewsForProduct(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromMap(doc.id, doc.data())).toList());
  }

  // Update the average rating for a product
  Future<void> _updateAverageRating(String productId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .get();

      if (reviewsSnapshot.docs.isEmpty) {
        // No reviews, set rating to 0
        await _firestore.collection('products').doc(productId).update({
          'averageRating': 0.0,
          'reviewCount': 0,
        });
        return;
      }

      double totalRating = 0;
      for (final doc in reviewsSnapshot.docs) {
        totalRating += (doc.data()['rating'] as num?)?.toDouble() ?? 0.0;
      }

      final average = totalRating / reviewsSnapshot.docs.length;
      final reviewCount = reviewsSnapshot.docs.length;

      await _firestore.collection('products').doc(productId).update({
        'averageRating': average,
        'reviewCount': reviewCount,
      });
    } catch (e) {
      print('Error updating average rating for product $productId: $e');
      // It might be useful to handle this error, but for now, we just print it
    }
  }
}
