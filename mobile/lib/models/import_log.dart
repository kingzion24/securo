double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

class ImportLog {
  const ImportLog({
    required this.id,
    this.accountName,
    required this.entity,
    required this.filename,
    required this.transactionCount,
    required this.totalCredit,
    required this.totalDebit,
    required this.createdAt,
  });

  factory ImportLog.fromJson(Map<String, dynamic> json) => ImportLog(
        id: json['id'] as String,
        accountName: json['account_name'] as String?,
        entity: json['entity'] as String? ?? 'transactions',
        filename: json['filename'] as String,
        transactionCount: json['transaction_count'] as int? ?? 0,
        totalCredit: _toDouble(json['total_credit']),
        totalDebit: _toDouble(json['total_debit']),
        createdAt: json['created_at'] as String,
      );

  final String id;
  final String? accountName;
  final String entity;
  final String filename;
  final int transactionCount;
  final double totalCredit;
  final double totalDebit;
  final String createdAt;
}
