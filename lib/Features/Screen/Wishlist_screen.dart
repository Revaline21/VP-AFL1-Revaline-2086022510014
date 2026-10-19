import 'package:flutter/material.dart';
import 'Widget/vault_item.dart';
import 'Widget/wishlist_item.dart';
import 'Widget/Wishlist_tile.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key, required this.items, required this.onBought});

  final List<WishlistItem> items;

  final void Function(WishlistItem item, Condition condition) onBought;

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  double get _totalTarget =>
      widget.items.fold(0, (sum, i) => sum + i.targetPrice);

  Future<void> _add() async {
    final name = TextEditingController();
    final category = TextEditingController();
    final price = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah ke Wishlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Nama')),
            TextField(
                controller: category,
                decoration: const InputDecoration(labelText: 'Kategori')),
            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga target (Rp)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Simpan')),
        ],
      ),
    );

    final n = name.text.trim();
    final c = category.text.trim();
    final p = double.tryParse(price.text.trim());
    name.dispose();
    category.dispose();
    price.dispose();

    if (ok == true && n.isNotEmpty && c.isNotEmpty && p != null) {
      setState(() => widget.items.add(WishlistItem(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: n,
            category: c,
            targetPrice: p,
          )));
    }
  }

  Future<void> _markBought(WishlistItem item) async {
    final condition = await showDialog<Condition>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('Kondisi "${item.name}"?'),
        children: [
          for (final c in Condition.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, c),
              child: Text(c.label),
            ),
        ],
      ),
    );
    if (condition == null) return;

    widget.onBought(item, condition);
    setState(() => widget.items.removeWhere((i) => i.id == item.id));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${item.name}" dipindah ke Vault')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Wishlist masih kosong.'))
          : Column(
              children: [
                ListTile(
                  title: const Text('Total target belanja'),
                  trailing: Text('Rp ${_totalTarget.toStringAsFixed(0)}'),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: items.length,
                    itemBuilder: (_, i) => WishlistTile(
                      item: items[i],
                      onBought: () => _markBought(items[i]),
                      onDelete: () =>
                          setState(() => items.removeWhere((e) => e.id == items[i].id)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}