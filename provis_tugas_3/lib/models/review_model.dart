import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String userName;
  final int rating;
  final String comment;
  final Timestamp createdAt;

  ReviewModel({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // Factory constructor untuk membuat instance dari DocumentSnapshot
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      userName: data['userName'] ?? 'Anonymous',
      rating: (data['rating'] as num).toInt(),
      comment: data['comment'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
