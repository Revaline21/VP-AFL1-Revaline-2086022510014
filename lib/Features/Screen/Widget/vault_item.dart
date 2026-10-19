enum Condition { mint, nearMint, good, fair }

extension ConditionLabel on Condition {
  String get label => switch (this) {
        Condition.mint => 'Nice',
        Condition.nearMint => 'Not Bad',
        Condition.good => 'Good',
        Condition.fair => 'Fair',
      };
}

class VaultItem {
  const VaultItem({
    required this.id,
    required this.name,
    required this.category,
    required this.value,
    required this.condition,
    required this.purchaseDate,
  });

  final String id;
  final String name;
  final String category;
  final double value;
  final Condition condition;
  final DateTime purchaseDate;
}