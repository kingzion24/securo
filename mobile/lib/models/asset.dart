double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

double? _toDoubleOrNull(Object? value) =>
    value == null ? null : _toDouble(value);

class Asset {
  const Asset({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    this.units,
    this.currentValue,
    this.currentValuePrimary,
    this.gainLoss,
    this.gainLossPrimary,
    required this.isArchived,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String? ?? 'other',
        currency: json['currency'] as String? ?? 'USD',
        units: _toDoubleOrNull(json['units']),
        currentValue: _toDoubleOrNull(json['current_value']),
        currentValuePrimary: _toDoubleOrNull(json['current_value_primary']),
        gainLoss: _toDoubleOrNull(json['gain_loss']),
        gainLossPrimary: _toDoubleOrNull(json['gain_loss_primary']),
        isArchived: json['is_archived'] as bool? ?? false,
      );

  final String id;
  final String name;
  final String type;
  final String currency;
  final double? units;
  final double? currentValue;
  final double? currentValuePrimary;
  final double? gainLoss;
  final double? gainLossPrimary;
  final bool isArchived;
}
