part of 'savings_cubit.dart';

enum CreateStatus { idle, submitting, success, failure }

class SavingsState extends Equatable {
  const SavingsState({
    this.status = LoadStatus.initial,
    this.plans = const [],
    this.errorMessage,
    this.createStatus = CreateStatus.idle,
  });

  final LoadStatus status;
  final List<SavingsPlan> plans;
  final String? errorMessage;
  final CreateStatus createStatus;

  double get totalSavings =>
      AppConstants.baseBalance +
      plans
          .where((p) => !p.isSeed)
          .fold<double>(0, (sum, p) => sum + p.monthlyContribution);

  List<SavingsPlan> get recentPlans => plans.take(3).toList();

  SavingsState copyWith({
    LoadStatus? status,
    List<SavingsPlan>? plans,
    String? errorMessage,
    CreateStatus? createStatus,
  }) {
    return SavingsState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      errorMessage: errorMessage ?? this.errorMessage,
      createStatus: createStatus ?? this.createStatus,
    );
  }

  @override
  List<Object?> get props => [status, plans, errorMessage, createStatus];
}
