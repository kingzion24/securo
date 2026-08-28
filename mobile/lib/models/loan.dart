double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

class Loan {
  const Loan({
    required this.id,
    required this.personName,
    required this.direction,
    required this.principalAmount,
    required this.currency,
    required this.date,
    required this.status,
    this.repaidAmount = 0,
    this.remainingAmount = 0,
    this.percentage = 0,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json['id'] as String,
        personName: json['person_name'] as String,
        direction: json['direction'] as String,
        principalAmount: _toDouble(json['principal_amount']),
        currency: json['currency'] as String? ?? 'USD',
        date: json['date'] as String,
        status: json['status'] as String? ?? 'open',
        repaidAmount: _toDouble(json['repaid_amount']),
        remainingAmount: _toDouble(json['remaining_amount']),
        percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      );

  final String id;
  final String personName;

  /// `they_owe_me` or `i_owe_them`.
  final String direction;
  final double principalAmount;
  final String currency;
  final String date;
  final String status;
  final double repaidAmount;
  final double remainingAmount;
  final double percentage;

  bool get theyOweMe => direction == 'they_owe_me';
}
