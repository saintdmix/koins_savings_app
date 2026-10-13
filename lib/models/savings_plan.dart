import 'package:equatable/equatable.dart';

class SavingsPlan extends Equatable {
  const SavingsPlan({
    required this.id,
    required this.name,
    required this.productId,
    required this.productName,
    required this.targetAmount,
    required this.monthlyContribution,
    required this.durationMonths,
    required this.createdAt,
    this.frequency = 'Monthly',
    this.isSeed = false,
  });

  final String id;
  final String name;
  final String productId;
  final String productName;
  final double targetAmount;
  final double monthlyContribution;
  final int durationMonths;
  final DateTime createdAt;
  final String frequency;

  final bool isSeed;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'productId': productId,
        'productName': productName,
        'targetAmount': targetAmount,
        'monthlyContribution': monthlyContribution,
        'durationMonths': durationMonths,
        'createdAt': createdAt.toIso8601String(),
        'frequency': frequency,
      };

  factory SavingsPlan.fromJson(Map<String, dynamic> json) => SavingsPlan(
        id: json['id'] as String,
        name: json['name'] as String,
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        targetAmount: (json['targetAmount'] as num).toDouble(),
        monthlyContribution: (json['monthlyContribution'] as num).toDouble(),
        durationMonths: json['durationMonths'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        frequency: json['frequency'] as String? ?? 'Monthly',
      );

  @override
  List<Object?> get props => [id, name, productId, productName, targetAmount, monthlyContribution, durationMonths, createdAt, frequency, isSeed];
}
