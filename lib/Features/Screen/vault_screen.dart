import 'package:flutter/material.dart';
import 'Widget/vault_item.dart';
import 'Widget/add_item_sheet.dart';
import 'Widget/condition_filter_bar.dart';
import 'Widget/vault_item_tile.dart';
import 'Widget/vault_summary_card.dart';
import 'Widget/wishlist_item.dart';
import 'item_detail_screen.dart';
import 'search_screen.dart';
import 'Wishlist_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key, this.initialItems});

  final List<VaultItem>? initialItems;

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  static const double _tabletBreakpoint = 700;

  late final List<VaultItem> _items;

  final List<WishlistItem> _wishlist = [
    const WishlistItem(
        id: 'w1', name: 'Nendoroid Zoro', category: 'Figure', targetPrice: 700000),
    const WishlistItem(
        id: 'w2', name: 'Jordan 1 Retro', category: 'Sneaker', targetPrice: 2500000),
  ];

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.initialItems ?? _defaultItems());
  }

  static List<VaultItem> _defaultItems() => [
        VaultItem(
          id: '1',
          name: 'Tanjiro Gundam',
          category: 'Figure',
          value: 850000,
          condition: Condition.mint,
          purchaseDate: DateTime(2025, 3, 12),
        ),
        VaultItem(
          id: '2',
          name: 'Adida',
          category: 'Sneaker',
          value: 3200000,
          condition: Condition.nearMint,
          purchaseDate: DateTime(2024, 11, 2),
        ),
        VaultItem(
          id: '3',
          name: 'Pokemon',
          category: 'TCG',
          value: 1500000,
          condition: Condition.good,
          purchaseDate: DateTime(2025, 6, 20),
        ),
      ];

  Condition? _filter;
  final double _goalValue = 10000000;

  List<VaultItem> get _visibleItems => _filter == null
      ? _items
      : _items.where((i) => i.condition == _filter).toList();

  double get _totalValue => _items.fold(0, (sum, i) => sum + i.value);

  void _addItem(VaultItem item) => setState(() => _items.add(item));

  void _removeItem(String id) =>
      setState(() => _items.removeWhere((i) => i.id == id));

  void _setFilter(Condition? c) => setState(() => _filter = c);

  void _openAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddItemSheet(onSubmit: _addItem),
    );
  }

  void _openDetail(VaultItem item) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ItemDetailScreen(item: item),
      ),
    );
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => SearchScreen(items: _items)),
    );
  }

  void _openWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => WishlistScreen(
          items: _wishlist,
          onBought: _buyFromWishlist,
        ),
      ),
    );
  }

  /// Pindahkan barang wishlist yang sudah dibeli ke Vault.
  void _buyFromWishlist(WishlistItem w, Condition condition) {
    _addItem(VaultItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: w.name,
      category: w.category,
      value: w.targetPrice,
      condition: condition,
      purchaseDate: DateTime.now(),
    ));
  }

  Widget _summary() => VaultSummaryCard(
        totalValue: _totalValue,
        goalValue: _goalValue,
        itemCount: _items.length,
      );

  Widget _filterBar() => ConditionFilterBar(
        selected: _filter,
        onChanged: _setFilter,
      );

  /// Satu tile item; ketuk untuk membuka halaman detail.
  Widget _tile(VaultItem item) => InkWell(
        onTap: () => _openDetail(item),
        child: VaultItemTile(
          item: item,
          onDelete: () => _removeItem(item.id),
        ),
      );

  Widget _emptyState() {
    final theme = Theme.of(context);
    return Center(
      key: const Key('empty-state'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada item.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _openAddSheet,
              icon: const Icon(Icons.add),
              label: const Text('Tambah item pertama'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemList(List<VaultItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: items.length,
      itemBuilder: (_, i) => _tile(items[i]),
    );
  }

  Widget _wideLayout(List<VaultItem> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _summary(),
                _filterBar(),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: items.isEmpty ? _emptyState() : _itemList(items),
        ),
      ],
    );
  }

  Widget _narrowLayout(List<VaultItem> items) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _summary()),
        SliverToBoxAdapter(child: _filterBar()),
        if (items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _emptyState(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 88),
            sliver: SliverList.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => _tile(items[i]),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collector Vault'),
        actions: [
          IconButton(
            tooltip: 'Cari',
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
          IconButton(
            tooltip: 'Wishlist',
            icon: const Icon(Icons.favorite_border),
            onPressed: _openWishlist,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddSheet,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Item'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= _tabletBreakpoint) {
            return _wideLayout(items);
          }
          return _narrowLayout(items);
        },
      ),
    );
  }
}