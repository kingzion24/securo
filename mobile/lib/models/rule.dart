class Rule {
  const Rule({
    required this.id,
    required this.name,
    required this.conditionsOp,
    required this.conditions,
    required this.actions,
    required this.priority,
    required this.isActive,
  });

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        id: json['id'] as String,
        name: json['name'] as String,
        conditionsOp: json['conditions_op'] as String? ?? 'and',
        conditions: (json['conditions'] as List?)?.cast<Map<String, dynamic>>() ??
            const [],
        actions:
            (json['actions'] as List?)?.cast<Map<String, dynamic>>() ?? const [],
        priority: json['priority'] as int? ?? 0,
        isActive: json['is_active'] as bool? ?? true,
      );

  final String id;
  final String name;
  final String conditionsOp;
  final List<Map<String, dynamic>> conditions;
  final List<Map<String, dynamic>> actions;
  final int priority;
  final bool isActive;
}
