double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

class RecurringTransaction {
  const RecurringTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.currency,
    required this.type,
    required this.frequency,
    required this.nextOccurrence,
    required this.isActive,
    this.accountId,
    this.categoryId,
    this.dayOfMonth,
  });

  factory RecurringTransaction.fromJson(Map<String, dynamic> json) =>
      RecurringTransaction(
        id: json['id'] as String,
        description: json['description'] as String,
        amount: _toDouble(json['amount']),
        currency: json['currency'] as String? ?? 'USD',
        type: json['type'] as String? ?? 'debit',
        frequency: json['frequency'] as String? ?? 'monthly',
        nextOccurrence: json['next_occurrence'] as String,
        isActive: json['is_active'] as bool? ?? true,
        accountId: json['account_id'] as String?,
        categoryId: json['category_id'] as String?,
        dayOfMonth: json['day_of_month'] as int?,
      );

  final String id;
  final String description;
  final double amount;
  final String currency;
  final String type;
  final String frequency;
  final String nextOccurrence;
  final bool isActive;
  final String? accountId;
  final String? categoryId;
  final int? dayOfMonth;

  double get signedAmount => type == 'credit' ? amount.abs() : -amount.abs();
}
