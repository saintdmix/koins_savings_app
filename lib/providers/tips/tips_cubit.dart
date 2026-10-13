import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_exception.dart';
import '../../core/load_status.dart';
import '../../models/tip_model.dart';
import '../../repositories/tips_repository.dart';

part 'tips_state.dart';

class TipsCubit extends Cubit<TipsState> {
  TipsCubit(this._repository) : super(const TipsState());

  final TipsRepository _repository;

  Future<void> load() async {
    if (state.tips.isEmpty) emit(state.copyWith(status: LoadStatus.loading));
    try {
      final tips = await _repository.getTips();
      emit(state.copyWith(status: LoadStatus.success, tips: tips));
    } on AppException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: LoadStatus.failure,
        errorMessage: 'Unexpected error. Please try again.',
      ));
    }
  }
}
