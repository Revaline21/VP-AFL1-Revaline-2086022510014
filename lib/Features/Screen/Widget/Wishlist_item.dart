class WishlistItem {
  const WishlistItem({
    required this.id,
    required this.name,
    required this.category,
    required this.targetPrice,
  });

  final String id;
  final String name;
  final String category;
  final double targetPrice;
}