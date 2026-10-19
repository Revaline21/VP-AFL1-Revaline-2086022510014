import 'package:flutter/material.dart';
import '../Widget/vault_item.dart';

class ConditionFilterBar extends StatelessWidget {
  const ConditionFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Condition? selected;
  final ValueChanged<Condition?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Semua'),
            selected: selected == null,
            onSelected: (_) => onChanged(null),
          ),
          for (final c in Condition.values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(c.label),
              selected: selected == c,
              onSelected: (_) => onChanged(c),
            ),
          ],
        ],
      ),
    );
  }
}