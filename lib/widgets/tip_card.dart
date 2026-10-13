import 'package:flutter/material.dart';

import '../models/tip_model.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key, required this.tip});

  final TipModel tip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.filled(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(Icons.lightbulb_outline, color: theme.colorScheme.tertiary),
        title: Text(tip.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(tip.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
