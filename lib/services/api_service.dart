import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_response.dart';
import '../core/constants/api_constants.dart';
import '../models/category_model.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  // Future<ProductResponse> getProducts({int limit = 20, int skip = 0}) async {
  //   try {
  //     // debugPrint('=================================');

  //     // debugPrint('BASE URL  : ${dio.options.baseUrl}');
  //     // debugPrint('ENDPOINT  : ${ApiConstants.products}');
  //     // debugPrint('FULL URL  : ${dio.options.baseUrl}${ApiConstants.products}');

  //     // debugPrint('=================================');

  //     final response = await dio.get(
  //       ApiConstants.products,
  //       queryParameters: {'limit': limit, 'skip': skip},
  //     );
  //     final result = ProductResponse.fromJson(response.data);

  //     return result;
  //   } on DioException catch (e) {
  //     final box = Hive.box('product_cache');
  //     final cached = box.get('products_$skip');

  //     if (cached != null) {
  //       return ProductResponse.fromJson(cached);
  //     }
  //     throw Exception(e.message ?? 'Failed to fetch products');
  //   }
  // }

  Future<ProductResponse> getProducts({int limit = 20, int skip = 0}) async {
    try {
      final response = await dio.get(
        ApiConstants.products,
        queryParameters: {'limit': limit, 'skip': skip},
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('products_$skip', jsonEncode(response.data));

      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch');
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
      final response = await dio.get('products/category/$category');

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
