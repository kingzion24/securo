double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

double? _toDoubleOrNull(Object? value) =>
    value == null ? null : _toDouble(value);

class BudgetVsActual {
  const BudgetVsActual({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    this.groupName,
    this.budgetAmount,
    required this.actualAmount,
    this.percentageUsed,
    required this.isRecurring,
  });

  factory BudgetVsActual.fromJson(Map<String, dynamic> json) => BudgetVsActual(
        categoryId: json['category_id'] as String,
        categoryName: json['category_name'] as String,
        categoryIcon: json['category_icon'] as String? ?? '',
        categoryColor: json['category_color'] as String? ?? '',
        groupName: json['group_name'] as String?,
        budgetAmount: _toDoubleOrNull(json['budget_amount']),
        actualAmount: _toDouble(json['actual_amount']),
        percentageUsed: _toDoubleOrNull(json['percentage_used']),
        isRecurring: json['is_recurring'] as bool? ?? false,
      );

  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final String? groupName;
  final double? budgetAmount;
  final double actualAmount;
  final double? percentageUsed;
  final bool isRecurring;

  double get progress =>
      budgetAmount == null || budgetAmount == 0
          ? 0
          : (actualAmount / budgetAmount!).clamp(0, 1.5);

  bool get isOverBudget => budgetAmount != null && actualAmount > budgetAmount!;
}
