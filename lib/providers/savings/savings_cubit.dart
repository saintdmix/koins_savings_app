import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../../core/load_status.dart';
import '../../models/savings_plan.dart';
import '../../models/savings_product.dart';
import '../../repositories/savings_repository.dart';

part 'savings_state.dart';

class SavingsCubit extends Cubit<SavingsState> {
  SavingsCubit(this._repository) : super(const SavingsState());

  final SavingsRepository _repository;

  Future<void> load() async {
    if (state.plans.isEmpty) emit(state.copyWith(status: LoadStatus.loading));
    try {
      final plans = await _repository.getPlans();
      emit(state.copyWith(status: LoadStatus.success, plans: plans));
    } catch (_) {
      emit(state.copyWith(
        status: LoadStatus.failure,
        errorMessage: 'Could not load your savings. Please try again.',
      ));
    }
  }

  Future<void> createPlan({
    required String name,
    required SavingsProduct product,
    required double targetAmount,
    required double monthlyContribution,
    required int durationMonths,
  }) async {
    emit(state.copyWith(createStatus: CreateStatus.submitting));
    try {
      await _repository.createPlan(
        name: name,
        product: product,
        targetAmount: targetAmount,
        monthlyContribution: monthlyContribution,
        durationMonths: durationMonths,
      );
      final plans = await _repository.getPlans();
      emit(state.copyWith(
        status: LoadStatus.success,
        plans: plans,
        createStatus: CreateStatus.success,
      ));
    } catch (_) {
      emit(state.copyWith(
        createStatus: CreateStatus.failure,
        errorMessage: 'Could not save your savings plan. Please try again.',
      ));
    }
  }

  void resetCreateStatus() => emit(state.copyWith(createStatus: CreateStatus.idle));
}
