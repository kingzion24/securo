class Collection {
  const Collection({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.accountIds,
    required this.walletIds,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String? ?? 'folder',
        color: json['color'] as String? ?? '#6366F1',
        accountIds: (json['account_ids'] as List?)?.cast<String>() ?? const [],
        walletIds: (json['wallet_ids'] as List?)?.cast<String>() ?? const [],
      );

  final String id;
  final String name;
  final String icon;
  final String color;
  final List<String> accountIds;
  final List<String> walletIds;
}
