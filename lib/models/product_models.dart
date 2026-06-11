class ProductModels {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String description;
  final double rating;
  final int stock;
  final String category;

  const ProductModels({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
    required this.rating,
    required this.category,
    required this.stock
  });

  factory ProductModels.fromJson(Map<String, dynamic> json) => ProductModels(
    id: json['id'],
    title: json['title'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    thumbnail: json['thumbnail'] ?? '',
    description: json['description'] ?? '',
    rating: (json['rating'] ?? 0).toDouble(),
    category: json['category'] ?? '',
    stock: json['stock'] ?? 0
  );
}
