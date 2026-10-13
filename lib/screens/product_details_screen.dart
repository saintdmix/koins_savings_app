import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/app_router.dart';
import '../providers/products/products_cubit.dart';
import '../utils/formatters.dart';
import '../utils/product_icons.dart';
import '../widgets/primary_button.dart';
import '../widgets/responsive_body.dart';
import '../widgets/state_views.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = context.select(
      (ProductsCubit c) => c.state.products.where((p) => p.id == productId).firstOrNull,
    );
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Savings Details')),
        body: EmptyState(
          icon: Icons.search_off,
          title: 'Product not found',
          message: 'This savings product is no longer available.',
          actionLabel: 'Back to products',
          onAction: () => context.go(AppRoutes.products),
        ),
      );
    }

    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(label, style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
              const Spacer(),
              Text(value, style: theme.textTheme.titleMedium),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Savings Details')),
      body: SafeArea(
        child: ResponsiveBody(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Hero(
                  tag: 'product-icon-${product.id}',
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(productIcon(product.id), size: 36, color: scheme.onPrimaryContainer),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Card.filled(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      row('Plan Name', product.name),
                      const Divider(height: 1),
                      row('Interest Rate', product.interestLabel),
                      const Divider(height: 1),
                      row('Minimum Deposit', Formatters.naira(product.minimumDeposit)),
                      const Divider(height: 1),
                      row('Duration', product.durationLabel),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: PrimaryButton(
            label: 'Create Savings',
            icon: Icons.add,
            onPressed: () => context.push('${AppRoutes.create}?product=${product.id}'),
          ),
        ),
      ),
    );
  }
}
