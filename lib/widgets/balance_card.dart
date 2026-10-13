import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, required this.total});

  final double total;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primary.withValues(alpha: 0.7)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total Savings',
                style: textTheme.titleMedium?.copyWith(color: scheme.onPrimary),
              ),
              const Spacer(),
              IconButton(
                tooltip: _visible ? 'Hide balance' : 'Show balance',
                color: scheme.onPrimary,
                icon: Icon(_visible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _visible = !_visible),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _visible ? Formatters.naira(widget.total) : '₦ ••••••',
              key: ValueKey(_visible),
              style: textTheme.displaySmall?.copyWith(
                color: scheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.trending_up, size: 18, color: scheme.onPrimary),
              const SizedBox(width: 6),
              Text(
                'Earning up to 18% p.a.',
                style: textTheme.bodyMedium?.copyWith(color: scheme.onPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
