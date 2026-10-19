import 'package:flutter/material.dart';
import 'wishlist_item.dart';

class WishlistTile extends StatelessWidget {
  const WishlistTile({
    super.key,
    required this.item,
    required this.onBought,
    required this.onDelete,
  });

  final WishlistItem item;
  final VoidCallback onBought;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(item.category[0].toUpperCase())),
      title: Text(item.name),
      subtitle: Text(
          '${item.category} • target Rp ${item.targetPrice.toStringAsFixed(0)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Sudah dibeli',
            icon: const Icon(Icons.check_circle_outline),
            onPressed: onBought,
          ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}