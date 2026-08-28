class SplitGroup {
  const SplitGroup({
    required this.id,
    required this.name,
    required this.kind,
    required this.defaultCurrency,
    required this.icon,
    required this.color,
    required this.isArchived,
    this.memberCount = 0,
  });

  factory SplitGroup.fromJson(Map<String, dynamic> json) => SplitGroup(
        id: json['id'] as String,
        name: json['name'] as String,
        kind: json['kind'] as String? ?? 'social',
        defaultCurrency: json['default_currency'] as String? ?? 'USD',
        icon: json['icon'] as String? ?? 'users',
        color: json['color'] as String? ?? '#6B7280',
        isArchived: json['is_archived'] as bool? ?? false,
        memberCount: (json['members'] as List?)?.length ?? 0,
      );

  final String id;
  final String name;
  final String kind;
  final String defaultCurrency;
  final String icon;
  final String color;
  final bool isArchived;
  final int memberCount;
}
