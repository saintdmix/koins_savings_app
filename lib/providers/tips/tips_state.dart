part of 'tips_cubit.dart';

class TipsState extends Equatable {
  const TipsState({
    this.status = LoadStatus.initial,
    this.tips = const [],
    this.errorMessage,
  });

  final LoadStatus status;
  final List<TipModel> tips;
  final String? errorMessage;

  TipsState copyWith({
    LoadStatus? status,
    List<TipModel>? tips,
    String? errorMessage,
  }) {
    return TipsState(
      status: status ?? this.status,
      tips: tips ?? this.tips,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tips, errorMessage];
}
