import 'product_models.dart';

class ProductResponse {
  final List<ProductModels> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductResponse(
      products: (json['products'] as List)
          .map(
            (product) =>
                ProductModels.fromJson(product),
          )
          .toList(),

      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}