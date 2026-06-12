import 'review_model.dart';

class ProductModels {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ReviewModel> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final String thumbnail;
  final List<String> images;

  const ProductModels({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.thumbnail,
    required this.images,
  });

  // Computed — discounted price
  double get discountedPrice => price - (price * discountPercentage / 100);

  factory ProductModels.fromJson(Map<String, dynamic> json) => ProductModels(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
        rating: (json['rating'] ?? 0).toDouble(),
        stock: json['stock'] ?? 0,
        tags: List<String>.from(json['tags'] ?? []),
        brand: json['brand'] ?? '',
        sku: json['sku'] ?? '',
        warrantyInformation: json['warrantyInformation'] ?? '',
        shippingInformation: json['shippingInformation'] ?? '',
        availabilityStatus: json['availabilityStatus'] ?? '',
        reviews: (json['reviews'] as List<dynamic>? ?? [])
            .map((r) => ReviewModel.fromJson(r))
            .toList(),
        returnPolicy: json['returnPolicy'] ?? '',
        minimumOrderQuantity: json['minimumOrderQuantity'] ?? 1,
        thumbnail: json['thumbnail'] ?? '',
        images: List<String>.from(json['images'] ?? []),
      );
}