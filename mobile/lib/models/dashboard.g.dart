// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardSummaryImpl _$$DashboardSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardSummaryImpl(
  totalBalance: json['total_balance'] == null
      ? const <String, double>{}
      : _toCurrencyMap(json['total_balance']),
  totalBalancePrimary: json['total_balance_primary'] == null
      ? 0
      : _toDouble(json['total_balance_primary']),
  projectedBalance: json['projected_balance'] == null
      ? const <String, double>{}
      : _toCurrencyMap(json['projected_balance']),
  projectedBalancePrimary: json['projected_balance_primary'] == null
      ? 0
      : _toDouble(json['projected_balance_primary']),
  balanceDate: json['balance_date'] as String?,
  monthlyIncome: json['monthly_income'] == null
      ? 0
      : _toDouble(json['monthly_income']),
  monthlyExpenses: json['monthly_expenses'] == null
      ? 0
      : _toDouble(json['monthly_expenses']),
  monthlyIncomePrimary: json['monthly_income_primary'] == null
      ? 0
      : _toDouble(json['monthly_income_primary']),
  monthlyExpensesPrimary: json['monthly_expenses_primary'] == null
      ? 0
      : _toDouble(json['monthly_expenses_primary']),
  projectedIncome: _toDoubleOrNull(json['projected_income']),
  projectedExpenses: _toDoubleOrNull(json['projected_expenses']),
  projectedIncomePrimary: _toDoubleOrNull(json['projected_income_primary']),
  projectedExpensesPrimary: _toDoubleOrNull(json['projected_expenses_primary']),
  accountsCount: (json['accounts_count'] as num?)?.toInt() ?? 0,
  pendingCategorization: (json['pending_categorization'] as num?)?.toInt() ?? 0,
  pendingCategorizationAmount: json['pending_categorization_amount'] == null
      ? 0
      : _toDouble(json['pending_categorization_amount']),
  assetsValue: json['assets_value'] == null
      ? const <String, double>{}
      : _toCurrencyMap(json['assets_value']),
  assetsValuePrimary: json['assets_value_primary'] == null
      ? 0
      : _toDouble(json['assets_value_primary']),
  primaryCurrency: json['primary_currency'] as String? ?? 'USD',
  pendingSharesNet: json['pending_shares_net'] == null
      ? 0
      : _toDouble(json['pending_shares_net']),
);

Map<String, dynamic> _$$DashboardSummaryImplToJson(
  _$DashboardSummaryImpl instance,
) => <String, dynamic>{
  'total_balance': instance.totalBalance,
  'total_balance_primary': instance.totalBalancePrimary,
  'projected_balance': instance.projectedBalance,
  'projected_balance_primary': instance.projectedBalancePrimary,
  'balance_date': instance.balanceDate,
  'monthly_income': instance.monthlyIncome,
  'monthly_expenses': instance.monthlyExpenses,
  'monthly_income_primary': instance.monthlyIncomePrimary,
  'monthly_expenses_primary': instance.monthlyExpensesPrimary,
  'projected_income': instance.projectedIncome,
  'projected_expenses': instance.projectedExpenses,
  'projected_income_primary': instance.projectedIncomePrimary,
  'projected_expenses_primary': instance.projectedExpensesPrimary,
  'accounts_count': instance.accountsCount,
  'pending_categorization': instance.pendingCategorization,
  'pending_categorization_amount': instance.pendingCategorizationAmount,
  'assets_value': instance.assetsValue,
  'assets_value_primary': instance.assetsValuePrimary,
  'primary_currency': instance.primaryCurrency,
  'pending_shares_net': instance.pendingSharesNet,
};

_$SpendingByCategoryImpl _$$SpendingByCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$SpendingByCategoryImpl(
  categoryId: json['category_id'] as String?,
  categoryName: json['category_name'] as String,
  categoryIcon: json['category_icon'] as String? ?? '',
  categoryColor: json['category_color'] as String? ?? '',
  total: json['total'] == null ? 0 : _toDouble(json['total']),
  percentage: json['percentage'] == null ? 0 : _toDouble(json['percentage']),
);

Map<String, dynamic> _$$SpendingByCategoryImplToJson(
  _$SpendingByCategoryImpl instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'category_icon': instance.categoryIcon,
  'category_color': instance.categoryColor,
  'total': instance.total,
  'percentage': instance.percentage,
};

_$MonthlyTrendImpl _$$MonthlyTrendImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyTrendImpl(
      month: json['month'] as String,
      income: json['income'] == null ? 0 : _toDouble(json['income']),
      expenses: json['expenses'] == null ? 0 : _toDouble(json['expenses']),
    );

Map<String, dynamic> _$$MonthlyTrendImplToJson(_$MonthlyTrendImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'income': instance.income,
      'expenses': instance.expenses,
    };

_$DailyBalanceImpl _$$DailyBalanceImplFromJson(Map<String, dynamic> json) =>
    _$DailyBalanceImpl(
      day: (json['day'] as num).toInt(),
      balance: _toDoubleOrNull(json['balance']),
    );

Map<String, dynamic> _$$DailyBalanceImplToJson(_$DailyBalanceImpl instance) =>
    <String, dynamic>{'day': instance.day, 'balance': instance.balance};

_$BalanceHistoryImpl _$$BalanceHistoryImplFromJson(Map<String, dynamic> json) =>
    _$BalanceHistoryImpl(
      current:
          (json['current'] as List<dynamic>?)
              ?.map((e) => DailyBalance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DailyBalance>[],
      previous:
          (json['previous'] as List<dynamic>?)
              ?.map((e) => DailyBalance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DailyBalance>[],
    );

Map<String, dynamic> _$$BalanceHistoryImplToJson(
  _$BalanceHistoryImpl instance,
) => <String, dynamic>{
  'current': instance.current.map((e) => e.toJson()).toList(),
  'previous': instance.previous.map((e) => e.toJson()).toList(),
};
