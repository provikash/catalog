import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import 'product_state.dart';
import 'package:dio/dio.dart';

final productProvider = NotifierProvider<ProductNotifier, ProductState>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<ProductState> {
  final apiService = ApiService(Dio());

  @override
  ProductState build() {
    return const ProductState();
  }

  Future<void> loadProducts() async {
    state = state.copywith(isLoading: true);

    try {
      final response = await apiService.getProducts(limit: 20, skip: 0);
      state = state.copywith(products: response.products, isLoading: false);
    } catch (e) {
     state = state.copywith(isLoading: false, error: e.toString());
    }
  }
}
