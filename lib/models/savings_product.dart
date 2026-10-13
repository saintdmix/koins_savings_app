import 'package:equatable/equatable.dart';

class SavingsProduct extends Equatable {
  const SavingsProduct({
    required this.id,
    required this.name,
    required this.interestRate,
    required this.durationLabel,
    required this.minimumDeposit,
    required this.description,
    this.durationMonths,
  });

  final String id;
  final String name;
  final double interestRate;
  final String durationLabel;
  final double minimumDeposit;
  final String description;

  final int? durationMonths;

  bool get isFlexible => durationMonths == null;

  String get interestLabel {
    final digits = interestRate % 1 == 0 ? 0 : 1;
    return '${interestRate.toStringAsFixed(digits)}% p.a.';
  }

  @override
  List<Object?> get props => [id, name, interestRate, durationLabel, minimumDeposit, description, durationMonths];
}
