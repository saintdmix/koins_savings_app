import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/app_router.dart';
import '../core/load_status.dart';
import '../providers/auth/auth_cubit.dart';
import '../providers/savings/savings_cubit.dart';
import '../providers/tips/tips_cubit.dart';
import '../utils/formatters.dart';
import '../widgets/balance_card.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/responsive_body.dart';
import '../widgets/savings_plan_tile.dart';
import '../widgets/state_views.dart';
import '../widgets/tip_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _refresh(BuildContext context) {
    return Future.wait([
      context.read<SavingsCubit>().load(),
      context.read<TipsCubit>().load(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.select((AuthCubit c) => c.state.user);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: ResponsiveBody(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                Text(
                  '${Formatters.greeting()}, ${user?.fullName ?? ''}',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Here's your savings overview",
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                BlocBuilder<SavingsCubit, SavingsState>(
                  buildWhen: (p, c) => p.totalSavings != c.totalSavings,
                  builder: (context, state) => BalanceCard(total: state.totalSavings),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.add_circle_outline,
                        label: 'Create Savings',
                        onTap: () => context.push(AppRoutes.create),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.storefront_outlined,
                        label: 'View Products',
                        onTap: () => context.go(AppRoutes.products),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Recent Savings', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                BlocBuilder<SavingsCubit, SavingsState>(
                  builder: (context, state) => _recentSavings(context, state),
                ),
                const SizedBox(height: 24),
                Text('Financial Tips', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                BlocBuilder<TipsCubit, TipsState>(
                  builder: (context, state) => _tips(context, state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _recentSavings(BuildContext context, SavingsState state) {
    switch (state.status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.failure:
        return ErrorState(
          message: state.errorMessage ?? 'Could not load your savings.',
          onRetry: () => context.read<SavingsCubit>().load(),
        );
      case LoadStatus.success:
        final plans = state.recentPlans;
        if (plans.isEmpty) {
          return EmptyState(
            icon: Icons.savings_outlined,
            title: 'No savings yet',
            message: 'Create your first savings plan to get started.',
            actionLabel: 'Create Savings',
            onAction: () => context.push(AppRoutes.create),
          );
        }
        return Column(
          children: [
            for (final (i, plan) in plans.indexed)
              FadeSlideIn(index: i, child: SavingsPlanTile(plan: plan)),
          ],
        );
    }
  }

  Widget _tips(BuildContext context, TipsState state) {
    switch (state.status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.failure:
        return ErrorState(
          message: state.errorMessage ?? 'Could not load tips.',
          onRetry: () => context.read<TipsCubit>().load(),
        );
      case LoadStatus.success:
        if (state.tips.isEmpty) {
          return const EmptyState(
            icon: Icons.lightbulb_outline,
            title: 'No tips right now',
            message: 'Check back later for new financial tips.',
          );
        }
        return Column(
          children: [
            for (final (i, tip) in state.tips.indexed)
              FadeSlideIn(index: i, child: TipCard(tip: tip)),
          ],
        );
    }
  }
}
