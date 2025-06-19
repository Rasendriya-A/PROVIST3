import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String productId; // DITAMBAHKAN - Penting untuk menautkan ke produk
  final String userId; // DITAMBAHKAN - Penting untuk menautkan ke pengguna
  final String userName;
  final int rating;
  final String comment;
  final Timestamp createdAt;

  ReviewModel({
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // Mengubah objek ReviewModel menjadi Map<String, dynamic> untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  // Factory constructor untuk membuat instance dari data Map Firestore
  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      productId: map['productId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      rating: (map['rating'] as num? ?? 0).toInt(),
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}
