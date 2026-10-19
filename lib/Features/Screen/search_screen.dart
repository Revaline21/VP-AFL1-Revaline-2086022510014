import 'package:flutter/material.dart';
import 'Widget/condition_filter_bar.dart';
import 'Widget/vault_item.dart';
import 'item_detail_screen.dart';

/// Screen: cari item berdasarkan nama/kategori, dengan filter kondisi.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.items});
  final List<VaultItem> items;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  Condition? _condition;

  List<VaultItem> get _results {
    final q = _query.trim().toLowerCase();
    return widget.items.where((i) {
      final matchText = q.isEmpty ||
          i.name.toLowerCase().contains(q) ||
          i.category.toLowerCase().contains(q);
      final matchCondition = _condition == null || i.condition == _condition;
      return matchText && matchCondition;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari nama atau kategori...',
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: Column(
        children: [
          ConditionFilterBar(
            selected: _condition,
            onChanged: (c) => setState(() => _condition = c),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('Tidak ada item yang cocok.'))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (_, i) {
                      final item = results[i];
                      return ListTile(
                        leading:
                            CircleAvatar(child: Text(item.category[0].toUpperCase())),
                        title: Text(item.name),
                        subtitle:
                            Text('${item.category} • ${item.condition.label}'),
                        trailing: Text('Rp ${item.value.toStringAsFixed(0)}'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => ItemDetailScreen(item: item)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}