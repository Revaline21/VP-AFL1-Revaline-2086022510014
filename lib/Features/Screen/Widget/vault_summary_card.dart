import 'package:flutter/material.dart';

class VaultSummaryCard extends StatelessWidget {
  const VaultSummaryCard({
    super.key,
    required this.totalValue,
    required this.goalValue,
    required this.itemCount,
  });

  final double totalValue;
  final double goalValue;
  final int itemCount;

  @override
Widget build(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  final text = Theme.of(context).textTheme;
  final progress = (totalValue / goalValue).clamp(0.0, 1.0);

  return Card.filled(
    color: scheme.primaryContainer,
    margin: const EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Nilai Koleksi',
            style: text.labelLarge?.copyWith(color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${totalValue.toStringAsFixed(0)}',
            style: text.displaySmall?.copyWith(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            color: scheme.primary,
            backgroundColor: scheme.surface,
          ),
          const SizedBox(height: 8),
          Text(
            '$itemCount item • Goal Rp ${goalValue.toStringAsFixed(0)} '
            '(${(progress * 100).toStringAsFixed(0)}%)',
            style: text.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
          ),
        ],
      ),
    ),
  );
}
}