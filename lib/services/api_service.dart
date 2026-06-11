import 'package:dio/dio.dart';

import '../models/product_response.dart';
import '../core/constants/api_constants.dart';
import '../models/category_model.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<ProductResponse> getProducts({int limit = 20, int skip = 0}) async {
    try {
      final response = await dio.get(
        ApiConstants.products,
        queryParameters: {'limit': limit, 'skip': skip},
      );

      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch products');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(ApiConstants.categories);

      return (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Field to fetch category products');
    }
  }

  Future<ProductResponse> getProductsByCategory(String category) async {
    try {
      final response = await dio.get('${ApiConstants.categories}/{$category}');

      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.message ?? 'Field to fetch Product by category products',
      );
    }
  }

  Future<ProductResponse> searchProducts(String query) async {
    try {
      final response = await dio.get(
        ApiConstants.search,
        queryParameters: {'q': query},
      );

      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to search products');
    }
  }
}
