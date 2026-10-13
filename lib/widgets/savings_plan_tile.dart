import 'package:flutter/material.dart';

import '../models/savings_plan.dart';
import '../utils/formatters.dart';
import '../utils/product_icons.dart';

class SavingsPlanTile extends StatelessWidget {
  const SavingsPlanTile({super.key, required this.plan});

  final SavingsPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.filled(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(productIcon(plan.productId), color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(plan.name, style: theme.textTheme.titleMedium),
        subtitle: Text('${plan.frequency} • ${plan.productName}'),
        trailing: Text(
          Formatters.naira(plan.targetAmount),
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
