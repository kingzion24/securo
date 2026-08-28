double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

class GoalSummary {
  const GoalSummary({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.currency,
    this.targetDate,
    required this.status,
    this.icon,
    this.color,
    this.percentage = 0,
    this.onTrack,
  });

  factory GoalSummary.fromJson(Map<String, dynamic> json) => GoalSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        targetAmount: _toDouble(json['target_amount']),
        currentAmount: _toDouble(json['current_amount']),
        currency: json['currency'] as String? ?? 'USD',
        targetDate: json['target_date'] as String?,
        status: json['status'] as String? ?? 'active',
        icon: json['icon'] as String?,
        color: json['color'] as String?,
        percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
        onTrack: json['on_track'] as String?,
      );

  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String currency;
  final String? targetDate;
  final String status;
  final String? icon;
  final String? color;
  final double percentage;
  final String? onTrack;

  bool get isAchieved => status == 'achieved' || percentage >= 100;
}
