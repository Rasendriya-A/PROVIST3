class ProductItemData {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String? description;

  ProductItemData({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
  });
}
