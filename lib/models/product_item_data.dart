class ProductItemData {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String? description;
  final int stock;
  final double averageRating;
  final int reviewCount;

  ProductItemData({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
    required this.stock,
    this.averageRating = 0.0,
    this.reviewCount = 0,
  });
}
