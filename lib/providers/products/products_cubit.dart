import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/load_status.dart';
import '../../models/savings_product.dart';
import '../../repositories/savings_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsState());

  final SavingsRepository _repository;

  Future<void> load() async {
    if (state.products.isEmpty) emit(state.copyWith(status: LoadStatus.loading));
    try {
      final products = await _repository.getProducts();
      emit(state.copyWith(status: LoadStatus.success, products: products));
    } catch (_) {
      emit(state.copyWith(
        status: LoadStatus.failure,
        errorMessage: 'Could not load savings products. Please try again.',
      ));
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void setFilter(ProductFilter filter) => emit(state.copyWith(filter: filter));
}
