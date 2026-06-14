import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProductListScreen(),
    );
  }
}

class ApiService {
  final Dio _dio = Dio();

  Future<List<Product>> getProduct() async {
    try {
      final results = await _dio.get(
        'https://dummyjson.com/products',
      );

      return (results.data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to get product');
    }
  }
}

class Product {
  final String title;
  final String thumbnail;
  final double price;

  Product({
    required this.title,
    required this.thumbnail,
    required this.price,
  });

  factory Product.fromJson(
    Map<String, dynamic> json,
  ) {
    return Product(
      title: json['title'],
      thumbnail: json['thumbnail'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

final productServiceProvider = Provider<ApiService>(
  (ref) => ApiService(),
);

final productsProvider = FutureProvider<List<Product>>(
  (ref) async {
    return ref
        .read(productServiceProvider)
        .getProduct();
  },
);

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final products = ref.watch(
      productsProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
        ),
      ),
      body: products.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
          ),
        ),
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (
            context,
            index,
          ) {
            final product = products[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                leading: Image.network(
                  product.thumbnail,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  product.title,
                ),
                subtitle: Text(
                  '\$${product.price}',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}