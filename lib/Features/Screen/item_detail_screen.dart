import 'package:flutter/material.dart';
import 'Widget/detail_row.dart';
import 'Widget/vault_item.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.item});
  final VaultItem item;

  String get _date {
    final d = item.purchaseDate;
    return '${d.day}/${d.month}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListView(
        children: [
          DetailRow(label: 'Kategori', value: item.category),
          DetailRow(label: 'Kondisi', value: item.condition.label),
          DetailRow(
              label: 'Nilai', value: 'Rp ${item.value.toStringAsFixed(0)}'),
          DetailRow(label: 'Tanggal beli', value: _date),
        ],
      ),
    );
  }
}