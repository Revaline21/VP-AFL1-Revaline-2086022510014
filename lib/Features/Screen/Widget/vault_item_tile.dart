import 'package:flutter/material.dart';
import '../Widget/vault_item.dart';

class VaultItemTile extends StatelessWidget {
  const VaultItemTile({
    super.key,
    required this.item,
    required this.onDelete,
  });

  final VaultItem item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final d = item.purchaseDate;
    return ListTile(
      leading: CircleAvatar(child: Text(item.category[0])),
      title: Text(item.name),
      subtitle: Text(
        '${item.condition.label} • dibeli ${d.day}/${d.month}/${d.year}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Rp ${item.value.toStringAsFixed(0)}'),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}