import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final String productId;
  final double rating;
  final String? comment;
  final Timestamp createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.productId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  // Create a review from a map
  factory Review.fromMap(String id, Map<String, dynamic> map) {
    return Review(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      userImageUrl: map['userImageUrl'],
      productId: map['productId'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'],
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}
