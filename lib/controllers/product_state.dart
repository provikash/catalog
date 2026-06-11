import '../models/category_model.dart';
import '../models/product_models.dart';

class ProductState {
  final List<ProductModels> products;
  final List<CategoryModel> categories;

  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String searchQuery;
  final String? selectedCategory;

  final int skip;
  final bool hasMore;

  const ProductState({
    this.products = const [],
    this.categories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategory,
    this.skip = 0,
    this.hasMore = true,
  });

  ProductState copywith({
    List<ProductModels>? products,
    List<CategoryModel>? categories,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    String? selectedCategory,
    int? skip,
    bool? hasMore,
  }) {
    return ProductState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      skip: skip ?? this.skip,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
