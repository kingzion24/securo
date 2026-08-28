import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard.freezed.dart';
part 'dashboard.g.dart';

/// Amounts arrive as JSON numbers, which Dart decodes as int when they have no
/// fractional part. Every money field goes through this so `0` and `0.0` are
/// both read as a double.
double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

double? _toDoubleOrNull(Object? value) =>
    value == null ? null : _toDouble(value);

Map<String, double> _toCurrencyMap(Object? value) => switch (value) {
      Map<String, dynamic> map => {
          for (final e in map.entries) e.key: _toDouble(e.value),
        },
      _ => <String, double>{},
    };

@freezed
class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    @JsonKey(fromJson: _toCurrencyMap)
    @Default(<String, double>{})
    Map<String, double> totalBalance,
    @JsonKey(fromJson: _toDouble) @Default(0) double totalBalancePrimary,
    @JsonKey(fromJson: _toCurrencyMap)
    @Default(<String, double>{})
    Map<String, double> projectedBalance,
    @JsonKey(fromJson: _toDouble) @Default(0) double projectedBalancePrimary,
    String? balanceDate,
    @JsonKey(fromJson: _toDouble) @Default(0) double monthlyIncome,
    @JsonKey(fromJson: _toDouble) @Default(0) double monthlyExpenses,
    @JsonKey(fromJson: _toDouble) @Default(0) double monthlyIncomePrimary,
    @JsonKey(fromJson: _toDouble) @Default(0) double monthlyExpensesPrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedIncome,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedExpenses,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedIncomePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedExpensesPrimary,
    @Default(0) int accountsCount,
    @Default(0) int pendingCategorization,
    @JsonKey(fromJson: _toDouble)
    @Default(0)
    double pendingCategorizationAmount,
    @JsonKey(fromJson: _toCurrencyMap)
    @Default(<String, double>{})
    Map<String, double> assetsValue,
    @JsonKey(fromJson: _toDouble) @Default(0) double assetsValuePrimary,
    @Default('USD') String primaryCurrency,

    /// Net pending balance from group splits, in the primary currency.
    /// Negative = net liability, positive = net receivable. Already accounts
    /// for partial settlements.
    @JsonKey(fromJson: _toDouble) @Default(0) double pendingSharesNet,
  }) = _DashboardSummary;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);
}

@freezed
class SpendingByCategory with _$SpendingByCategory {
  const factory SpendingByCategory({
    String? categoryId,
    required String categoryName,
    @Default('') String categoryIcon,
    @Default('') String categoryColor,
    @JsonKey(fromJson: _toDouble) @Default(0) double total,
    @JsonKey(fromJson: _toDouble) @Default(0) double percentage,
  }) = _SpendingByCategory;

  factory SpendingByCategory.fromJson(Map<String, dynamic> json) =>
      _$SpendingByCategoryFromJson(json);
}

@freezed
class MonthlyTrend with _$MonthlyTrend {
  const factory MonthlyTrend({
    required String month,
    @JsonKey(fromJson: _toDouble) @Default(0) double income,
    @JsonKey(fromJson: _toDouble) @Default(0) double expenses,
  }) = _MonthlyTrend;

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) =>
      _$MonthlyTrendFromJson(json);
}

@freezed
class DailyBalance with _$DailyBalance {
  const factory DailyBalance({
    required int day,
    @JsonKey(fromJson: _toDoubleOrNull) double? balance,
  }) = _DailyBalance;

  factory DailyBalance.fromJson(Map<String, dynamic> json) =>
      _$DailyBalanceFromJson(json);
}

@freezed
class BalanceHistory with _$BalanceHistory {
  const factory BalanceHistory({
    @Default(<DailyBalance>[]) List<DailyBalance> current,
    @Default(<DailyBalance>[]) List<DailyBalance> previous,
  }) = _BalanceHistory;

  factory BalanceHistory.fromJson(Map<String, dynamic> json) =>
      _$BalanceHistoryFromJson(json);
}
