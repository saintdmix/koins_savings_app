import '../models/savings_plan.dart';
import '../models/savings_product.dart';
import '../services/storage_service.dart';

class SavingsRepository {
  SavingsRepository(
    this._storage, {
    this.latency = const Duration(milliseconds: 600),
  });

  final StorageService _storage;

  final Duration latency;

  static const List<SavingsProduct> _products = [
    SavingsProduct(
      id: 'target',
      name: 'Target Savings',
      interestRate: 12,
      durationLabel: '12 Months',
      durationMonths: 12,
      minimumDeposit: 5000,
      description: 'Save towards a goal with disciplined monthly contributions.',
    ),
    SavingsProduct(
      id: 'fixed',
      name: 'Fixed Deposit',
      interestRate: 18,
      durationLabel: '6 Months',
      durationMonths: 6,
      minimumDeposit: 50000,
      description: 'Lock funds for a fixed period and earn our highest rate.',
    ),
    SavingsProduct(
      id: 'education',
      name: 'Education Savings',
      interestRate: 10,
      durationLabel: 'Flexible',
      minimumDeposit: 2000,
      description: 'Plan ahead for school fees with flexible contributions.',
    ),
    SavingsProduct(
      id: 'vacation',
      name: 'Vacation Savings',
      interestRate: 8,
      durationLabel: 'Flexible',
      minimumDeposit: 1000,
      description: 'Set money aside for your next trip, at your own pace.',
    ),
  ];

  static final List<SavingsPlan> _seedPlans = [
    SavingsPlan(
      id: 'seed_1',
      name: 'Emergency Fund',
      productId: 'target',
      productName: 'Target Savings',
      targetAmount: 120000,
      monthlyContribution: 10000,
      durationMonths: 12,
      frequency: 'Monthly',
      createdAt: DateTime(2026, 9, 1),
      isSeed: true,
    ),
    SavingsPlan(
      id: 'seed_2',
      name: 'New Laptop',
      productId: 'education',
      productName: 'Education Savings',
      targetAmount: 250000,
      monthlyContribution: 20000,
      durationMonths: 12,
      frequency: 'Weekly',
      createdAt: DateTime(2026, 8, 10),
      isSeed: true,
    ),
    SavingsPlan(
      id: 'seed_3',
      name: 'Vacation Fund',
      productId: 'vacation',
      productName: 'Vacation Savings',
      targetAmount: 180000,
      monthlyContribution: 15000,
      durationMonths: 12,
      frequency: 'Monthly',
      createdAt: DateTime(2026, 7, 5),
      isSeed: true,
    ),
  ];

  Future<List<SavingsProduct>> getProducts() async {
    await Future<void>.delayed(latency);
    return _products;
  }

  Future<List<SavingsPlan>> getPlans() async {
    final all = [..._storage.readPlans(), ..._seedPlans]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all;
  }

  Future<SavingsPlan> createPlan({
    required String name,
    required SavingsProduct product,
    required double targetAmount,
    required double monthlyContribution,
    required int durationMonths,
  }) async {
    await Future<void>.delayed(latency);
    final plan = SavingsPlan(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      productId: product.id,
      productName: product.name,
      targetAmount: targetAmount,
      monthlyContribution: monthlyContribution,
      durationMonths: durationMonths,
      createdAt: DateTime.now(),
    );
    await _storage.savePlans([..._storage.readPlans(), plan]);
    return plan;
  }
}
