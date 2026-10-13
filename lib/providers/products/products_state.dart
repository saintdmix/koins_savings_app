part of 'products_cubit.dart';

enum ProductFilter { all, flexible, fixedTerm }

extension ProductFilterLabel on ProductFilter {
  String get label => switch (this) {
        ProductFilter.all => 'All',
        ProductFilter.flexible => 'Flexible',
        ProductFilter.fixedTerm => 'Fixed term',
      };
}

class ProductsState extends Equatable {
  const ProductsState({
    this.status = LoadStatus.initial,
    this.products = const [],
    this.query = '',
    this.filter = ProductFilter.all,
    this.errorMessage,
  });

  final LoadStatus status;
  final List<SavingsProduct> products;
  final String query;
  final ProductFilter filter;
  final String? errorMessage;

  List<SavingsProduct> get visibleProducts {
    final q = query.trim().toLowerCase();
    return products.where((p) {
      final matchesFilter = switch (filter) {
        ProductFilter.all => true,
        ProductFilter.flexible => p.isFlexible,
        ProductFilter.fixedTerm => !p.isFlexible,
      };
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  ProductsState copyWith({
    LoadStatus? status,
    List<SavingsProduct>? products,
    String? query,
    ProductFilter? filter,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, query, filter, errorMessage];
}
