import 'package:flutter/material.dart';

import '../models/savings_product.dart';
import '../utils/product_icons.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onViewDetails});

  final SavingsProduct product;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'product-icon-${product.id}',
                  child: CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(productIcon(product.id), color: scheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(product.name, style: theme.textTheme.titleMedium)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.interestLabel,
                    style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSecondaryContainer),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, size: 18, color: scheme.outline),
                const SizedBox(width: 6),
                Text(product.durationLabel, style: theme.textTheme.bodyMedium),
                const Spacer(),
                FilledButton.tonal(onPressed: onViewDetails, child: const Text('View Details')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
