// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) {
  return _DashboardSummary.fromJson(json);
}

/// @nodoc
mixin _$DashboardSummary {
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get totalBalance => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get totalBalancePrimary => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get projectedBalance =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get projectedBalancePrimary => throw _privateConstructorUsedError;
  String? get balanceDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get monthlyIncome => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get monthlyExpenses => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get monthlyIncomePrimary => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get monthlyExpensesPrimary => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get projectedIncome => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get projectedExpenses => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get projectedIncomePrimary => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get projectedExpensesPrimary => throw _privateConstructorUsedError;
  int get accountsCount => throw _privateConstructorUsedError;
  int get pendingCategorization => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get pendingCategorizationAmount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get assetsValue => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get assetsValuePrimary => throw _privateConstructorUsedError;
  String get primaryCurrency => throw _privateConstructorUsedError;

  /// Net pending balance from group splits, in the primary currency.
  /// Negative = net liability, positive = net receivable. Already accounts
  /// for partial settlements.
  @JsonKey(fromJson: _toDouble)
  double get pendingSharesNet => throw _privateConstructorUsedError;

  /// Serializes this DashboardSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardSummaryCopyWith<DashboardSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardSummaryCopyWith<$Res> {
  factory $DashboardSummaryCopyWith(
    DashboardSummary value,
    $Res Function(DashboardSummary) then,
  ) = _$DashboardSummaryCopyWithImpl<$Res, DashboardSummary>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _toCurrencyMap) Map<String, double> totalBalance,
    @JsonKey(fromJson: _toDouble) double totalBalancePrimary,
    @JsonKey(fromJson: _toCurrencyMap) Map<String, double> projectedBalance,
    @JsonKey(fromJson: _toDouble) double projectedBalancePrimary,
    String? balanceDate,
    @JsonKey(fromJson: _toDouble) double monthlyIncome,
    @JsonKey(fromJson: _toDouble) double monthlyExpenses,
    @JsonKey(fromJson: _toDouble) double monthlyIncomePrimary,
    @JsonKey(fromJson: _toDouble) double monthlyExpensesPrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedIncome,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedExpenses,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedIncomePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedExpensesPrimary,
    int accountsCount,
    int pendingCategorization,
    @JsonKey(fromJson: _toDouble) double pendingCategorizationAmount,
    @JsonKey(fromJson: _toCurrencyMap) Map<String, double> assetsValue,
    @JsonKey(fromJson: _toDouble) double assetsValuePrimary,
    String primaryCurrency,
    @JsonKey(fromJson: _toDouble) double pendingSharesNet,
  });
}

/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res, $Val extends DashboardSummary>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBalance = null,
    Object? totalBalancePrimary = null,
    Object? projectedBalance = null,
    Object? projectedBalancePrimary = null,
    Object? balanceDate = freezed,
    Object? monthlyIncome = null,
    Object? monthlyExpenses = null,
    Object? monthlyIncomePrimary = null,
    Object? monthlyExpensesPrimary = null,
    Object? projectedIncome = freezed,
    Object? projectedExpenses = freezed,
    Object? projectedIncomePrimary = freezed,
    Object? projectedExpensesPrimary = freezed,
    Object? accountsCount = null,
    Object? pendingCategorization = null,
    Object? pendingCategorizationAmount = null,
    Object? assetsValue = null,
    Object? assetsValuePrimary = null,
    Object? primaryCurrency = null,
    Object? pendingSharesNet = null,
  }) {
    return _then(
      _value.copyWith(
            totalBalance: null == totalBalance
                ? _value.totalBalance
                : totalBalance // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            totalBalancePrimary: null == totalBalancePrimary
                ? _value.totalBalancePrimary
                : totalBalancePrimary // ignore: cast_nullable_to_non_nullable
                      as double,
            projectedBalance: null == projectedBalance
                ? _value.projectedBalance
                : projectedBalance // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            projectedBalancePrimary: null == projectedBalancePrimary
                ? _value.projectedBalancePrimary
                : projectedBalancePrimary // ignore: cast_nullable_to_non_nullable
                      as double,
            balanceDate: freezed == balanceDate
                ? _value.balanceDate
                : balanceDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            monthlyIncome: null == monthlyIncome
                ? _value.monthlyIncome
                : monthlyIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            monthlyExpenses: null == monthlyExpenses
                ? _value.monthlyExpenses
                : monthlyExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
            monthlyIncomePrimary: null == monthlyIncomePrimary
                ? _value.monthlyIncomePrimary
                : monthlyIncomePrimary // ignore: cast_nullable_to_non_nullable
                      as double,
            monthlyExpensesPrimary: null == monthlyExpensesPrimary
                ? _value.monthlyExpensesPrimary
                : monthlyExpensesPrimary // ignore: cast_nullable_to_non_nullable
                      as double,
            projectedIncome: freezed == projectedIncome
                ? _value.projectedIncome
                : projectedIncome // ignore: cast_nullable_to_non_nullable
                      as double?,
            projectedExpenses: freezed == projectedExpenses
                ? _value.projectedExpenses
                : projectedExpenses // ignore: cast_nullable_to_non_nullable
                      as double?,
            projectedIncomePrimary: freezed == projectedIncomePrimary
                ? _value.projectedIncomePrimary
                : projectedIncomePrimary // ignore: cast_nullable_to_non_nullable
                      as double?,
            projectedExpensesPrimary: freezed == projectedExpensesPrimary
                ? _value.projectedExpensesPrimary
                : projectedExpensesPrimary // ignore: cast_nullable_to_non_nullable
                      as double?,
            accountsCount: null == accountsCount
                ? _value.accountsCount
                : accountsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingCategorization: null == pendingCategorization
                ? _value.pendingCategorization
                : pendingCategorization // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingCategorizationAmount: null == pendingCategorizationAmount
                ? _value.pendingCategorizationAmount
                : pendingCategorizationAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            assetsValue: null == assetsValue
                ? _value.assetsValue
                : assetsValue // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            assetsValuePrimary: null == assetsValuePrimary
                ? _value.assetsValuePrimary
                : assetsValuePrimary // ignore: cast_nullable_to_non_nullable
                      as double,
            primaryCurrency: null == primaryCurrency
                ? _value.primaryCurrency
                : primaryCurrency // ignore: cast_nullable_to_non_nullable
                      as String,
            pendingSharesNet: null == pendingSharesNet
                ? _value.pendingSharesNet
                : pendingSharesNet // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardSummaryImplCopyWith<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  factory _$$DashboardSummaryImplCopyWith(
    _$DashboardSummaryImpl value,
    $Res Function(_$DashboardSummaryImpl) then,
  ) = __$$DashboardSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _toCurrencyMap) Map<String, double> totalBalance,
    @JsonKey(fromJson: _toDouble) double totalBalancePrimary,
    @JsonKey(fromJson: _toCurrencyMap) Map<String, double> projectedBalance,
    @JsonKey(fromJson: _toDouble) double projectedBalancePrimary,
    String? balanceDate,
    @JsonKey(fromJson: _toDouble) double monthlyIncome,
    @JsonKey(fromJson: _toDouble) double monthlyExpenses,
    @JsonKey(fromJson: _toDouble) double monthlyIncomePrimary,
    @JsonKey(fromJson: _toDouble) double monthlyExpensesPrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedIncome,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedExpenses,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedIncomePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? projectedExpensesPrimary,
    int accountsCount,
    int pendingCategorization,
    @JsonKey(fromJson: _toDouble) double pendingCategorizationAmount,
    @JsonKey(fromJson: _toCurrencyMap) Map<String, double> assetsValue,
    @JsonKey(fromJson: _toDouble) double assetsValuePrimary,
    String primaryCurrency,
    @JsonKey(fromJson: _toDouble) double pendingSharesNet,
  });
}

/// @nodoc
class __$$DashboardSummaryImplCopyWithImpl<$Res>
    extends _$DashboardSummaryCopyWithImpl<$Res, _$DashboardSummaryImpl>
    implements _$$DashboardSummaryImplCopyWith<$Res> {
  __$$DashboardSummaryImplCopyWithImpl(
    _$DashboardSummaryImpl _value,
    $Res Function(_$DashboardSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBalance = null,
    Object? totalBalancePrimary = null,
    Object? projectedBalance = null,
    Object? projectedBalancePrimary = null,
    Object? balanceDate = freezed,
    Object? monthlyIncome = null,
    Object? monthlyExpenses = null,
    Object? monthlyIncomePrimary = null,
    Object? monthlyExpensesPrimary = null,
    Object? projectedIncome = freezed,
    Object? projectedExpenses = freezed,
    Object? projectedIncomePrimary = freezed,
    Object? projectedExpensesPrimary = freezed,
    Object? accountsCount = null,
    Object? pendingCategorization = null,
    Object? pendingCategorizationAmount = null,
    Object? assetsValue = null,
    Object? assetsValuePrimary = null,
    Object? primaryCurrency = null,
    Object? pendingSharesNet = null,
  }) {
    return _then(
      _$DashboardSummaryImpl(
        totalBalance: null == totalBalance
            ? _value._totalBalance
            : totalBalance // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        totalBalancePrimary: null == totalBalancePrimary
            ? _value.totalBalancePrimary
            : totalBalancePrimary // ignore: cast_nullable_to_non_nullable
                  as double,
        projectedBalance: null == projectedBalance
            ? _value._projectedBalance
            : projectedBalance // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        projectedBalancePrimary: null == projectedBalancePrimary
            ? _value.projectedBalancePrimary
            : projectedBalancePrimary // ignore: cast_nullable_to_non_nullable
                  as double,
        balanceDate: freezed == balanceDate
            ? _value.balanceDate
            : balanceDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        monthlyIncome: null == monthlyIncome
            ? _value.monthlyIncome
            : monthlyIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        monthlyExpenses: null == monthlyExpenses
            ? _value.monthlyExpenses
            : monthlyExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
        monthlyIncomePrimary: null == monthlyIncomePrimary
            ? _value.monthlyIncomePrimary
            : monthlyIncomePrimary // ignore: cast_nullable_to_non_nullable
                  as double,
        monthlyExpensesPrimary: null == monthlyExpensesPrimary
            ? _value.monthlyExpensesPrimary
            : monthlyExpensesPrimary // ignore: cast_nullable_to_non_nullable
                  as double,
        projectedIncome: freezed == projectedIncome
            ? _value.projectedIncome
            : projectedIncome // ignore: cast_nullable_to_non_nullable
                  as double?,
        projectedExpenses: freezed == projectedExpenses
            ? _value.projectedExpenses
            : projectedExpenses // ignore: cast_nullable_to_non_nullable
                  as double?,
        projectedIncomePrimary: freezed == projectedIncomePrimary
            ? _value.projectedIncomePrimary
            : projectedIncomePrimary // ignore: cast_nullable_to_non_nullable
                  as double?,
        projectedExpensesPrimary: freezed == projectedExpensesPrimary
            ? _value.projectedExpensesPrimary
            : projectedExpensesPrimary // ignore: cast_nullable_to_non_nullable
                  as double?,
        accountsCount: null == accountsCount
            ? _value.accountsCount
            : accountsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingCategorization: null == pendingCategorization
            ? _value.pendingCategorization
            : pendingCategorization // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingCategorizationAmount: null == pendingCategorizationAmount
            ? _value.pendingCategorizationAmount
            : pendingCategorizationAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        assetsValue: null == assetsValue
            ? _value._assetsValue
            : assetsValue // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        assetsValuePrimary: null == assetsValuePrimary
            ? _value.assetsValuePrimary
            : assetsValuePrimary // ignore: cast_nullable_to_non_nullable
                  as double,
        primaryCurrency: null == primaryCurrency
            ? _value.primaryCurrency
            : primaryCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        pendingSharesNet: null == pendingSharesNet
            ? _value.pendingSharesNet
            : pendingSharesNet // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardSummaryImpl implements _DashboardSummary {
  const _$DashboardSummaryImpl({
    @JsonKey(fromJson: _toCurrencyMap)
    final Map<String, double> totalBalance = const <String, double>{},
    @JsonKey(fromJson: _toDouble) this.totalBalancePrimary = 0,
    @JsonKey(fromJson: _toCurrencyMap)
    final Map<String, double> projectedBalance = const <String, double>{},
    @JsonKey(fromJson: _toDouble) this.projectedBalancePrimary = 0,
    this.balanceDate,
    @JsonKey(fromJson: _toDouble) this.monthlyIncome = 0,
    @JsonKey(fromJson: _toDouble) this.monthlyExpenses = 0,
    @JsonKey(fromJson: _toDouble) this.monthlyIncomePrimary = 0,
    @JsonKey(fromJson: _toDouble) this.monthlyExpensesPrimary = 0,
    @JsonKey(fromJson: _toDoubleOrNull) this.projectedIncome,
    @JsonKey(fromJson: _toDoubleOrNull) this.projectedExpenses,
    @JsonKey(fromJson: _toDoubleOrNull) this.projectedIncomePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) this.projectedExpensesPrimary,
    this.accountsCount = 0,
    this.pendingCategorization = 0,
    @JsonKey(fromJson: _toDouble) this.pendingCategorizationAmount = 0,
    @JsonKey(fromJson: _toCurrencyMap)
    final Map<String, double> assetsValue = const <String, double>{},
    @JsonKey(fromJson: _toDouble) this.assetsValuePrimary = 0,
    this.primaryCurrency = 'USD',
    @JsonKey(fromJson: _toDouble) this.pendingSharesNet = 0,
  }) : _totalBalance = totalBalance,
       _projectedBalance = projectedBalance,
       _assetsValue = assetsValue;

  factory _$DashboardSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardSummaryImplFromJson(json);

  final Map<String, double> _totalBalance;
  @override
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get totalBalance {
    if (_totalBalance is EqualUnmodifiableMapView) return _totalBalance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_totalBalance);
  }

  @override
  @JsonKey(fromJson: _toDouble)
  final double totalBalancePrimary;
  final Map<String, double> _projectedBalance;
  @override
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get projectedBalance {
    if (_projectedBalance is EqualUnmodifiableMapView) return _projectedBalance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_projectedBalance);
  }

  @override
  @JsonKey(fromJson: _toDouble)
  final double projectedBalancePrimary;
  @override
  final String? balanceDate;
  @override
  @JsonKey(fromJson: _toDouble)
  final double monthlyIncome;
  @override
  @JsonKey(fromJson: _toDouble)
  final double monthlyExpenses;
  @override
  @JsonKey(fromJson: _toDouble)
  final double monthlyIncomePrimary;
  @override
  @JsonKey(fromJson: _toDouble)
  final double monthlyExpensesPrimary;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? projectedIncome;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? projectedExpenses;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? projectedIncomePrimary;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? projectedExpensesPrimary;
  @override
  @JsonKey()
  final int accountsCount;
  @override
  @JsonKey()
  final int pendingCategorization;
  @override
  @JsonKey(fromJson: _toDouble)
  final double pendingCategorizationAmount;
  final Map<String, double> _assetsValue;
  @override
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get assetsValue {
    if (_assetsValue is EqualUnmodifiableMapView) return _assetsValue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_assetsValue);
  }

  @override
  @JsonKey(fromJson: _toDouble)
  final double assetsValuePrimary;
  @override
  @JsonKey()
  final String primaryCurrency;

  /// Net pending balance from group splits, in the primary currency.
  /// Negative = net liability, positive = net receivable. Already accounts
  /// for partial settlements.
  @override
  @JsonKey(fromJson: _toDouble)
  final double pendingSharesNet;

  @override
  String toString() {
    return 'DashboardSummary(totalBalance: $totalBalance, totalBalancePrimary: $totalBalancePrimary, projectedBalance: $projectedBalance, projectedBalancePrimary: $projectedBalancePrimary, balanceDate: $balanceDate, monthlyIncome: $monthlyIncome, monthlyExpenses: $monthlyExpenses, monthlyIncomePrimary: $monthlyIncomePrimary, monthlyExpensesPrimary: $monthlyExpensesPrimary, projectedIncome: $projectedIncome, projectedExpenses: $projectedExpenses, projectedIncomePrimary: $projectedIncomePrimary, projectedExpensesPrimary: $projectedExpensesPrimary, accountsCount: $accountsCount, pendingCategorization: $pendingCategorization, pendingCategorizationAmount: $pendingCategorizationAmount, assetsValue: $assetsValue, assetsValuePrimary: $assetsValuePrimary, primaryCurrency: $primaryCurrency, pendingSharesNet: $pendingSharesNet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardSummaryImpl &&
            const DeepCollectionEquality().equals(
              other._totalBalance,
              _totalBalance,
            ) &&
            (identical(other.totalBalancePrimary, totalBalancePrimary) ||
                other.totalBalancePrimary == totalBalancePrimary) &&
            const DeepCollectionEquality().equals(
              other._projectedBalance,
              _projectedBalance,
            ) &&
            (identical(
                  other.projectedBalancePrimary,
                  projectedBalancePrimary,
                ) ||
                other.projectedBalancePrimary == projectedBalancePrimary) &&
            (identical(other.balanceDate, balanceDate) ||
                other.balanceDate == balanceDate) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.monthlyExpenses, monthlyExpenses) ||
                other.monthlyExpenses == monthlyExpenses) &&
            (identical(other.monthlyIncomePrimary, monthlyIncomePrimary) ||
                other.monthlyIncomePrimary == monthlyIncomePrimary) &&
            (identical(other.monthlyExpensesPrimary, monthlyExpensesPrimary) ||
                other.monthlyExpensesPrimary == monthlyExpensesPrimary) &&
            (identical(other.projectedIncome, projectedIncome) ||
                other.projectedIncome == projectedIncome) &&
            (identical(other.projectedExpenses, projectedExpenses) ||
                other.projectedExpenses == projectedExpenses) &&
            (identical(other.projectedIncomePrimary, projectedIncomePrimary) ||
                other.projectedIncomePrimary == projectedIncomePrimary) &&
            (identical(
                  other.projectedExpensesPrimary,
                  projectedExpensesPrimary,
                ) ||
                other.projectedExpensesPrimary == projectedExpensesPrimary) &&
            (identical(other.accountsCount, accountsCount) ||
                other.accountsCount == accountsCount) &&
            (identical(other.pendingCategorization, pendingCategorization) ||
                other.pendingCategorization == pendingCategorization) &&
            (identical(
                  other.pendingCategorizationAmount,
                  pendingCategorizationAmount,
                ) ||
                other.pendingCategorizationAmount ==
                    pendingCategorizationAmount) &&
            const DeepCollectionEquality().equals(
              other._assetsValue,
              _assetsValue,
            ) &&
            (identical(other.assetsValuePrimary, assetsValuePrimary) ||
                other.assetsValuePrimary == assetsValuePrimary) &&
            (identical(other.primaryCurrency, primaryCurrency) ||
                other.primaryCurrency == primaryCurrency) &&
            (identical(other.pendingSharesNet, pendingSharesNet) ||
                other.pendingSharesNet == pendingSharesNet));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    const DeepCollectionEquality().hash(_totalBalance),
    totalBalancePrimary,
    const DeepCollectionEquality().hash(_projectedBalance),
    projectedBalancePrimary,
    balanceDate,
    monthlyIncome,
    monthlyExpenses,
    monthlyIncomePrimary,
    monthlyExpensesPrimary,
    projectedIncome,
    projectedExpenses,
    projectedIncomePrimary,
    projectedExpensesPrimary,
    accountsCount,
    pendingCategorization,
    pendingCategorizationAmount,
    const DeepCollectionEquality().hash(_assetsValue),
    assetsValuePrimary,
    primaryCurrency,
    pendingSharesNet,
  ]);

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardSummaryImplCopyWith<_$DashboardSummaryImpl> get copyWith =>
      __$$DashboardSummaryImplCopyWithImpl<_$DashboardSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardSummaryImplToJson(this);
  }
}

abstract class _DashboardSummary implements DashboardSummary {
  const factory _DashboardSummary({
    @JsonKey(fromJson: _toCurrencyMap) final Map<String, double> totalBalance,
    @JsonKey(fromJson: _toDouble) final double totalBalancePrimary,
    @JsonKey(fromJson: _toCurrencyMap)
    final Map<String, double> projectedBalance,
    @JsonKey(fromJson: _toDouble) final double projectedBalancePrimary,
    final String? balanceDate,
    @JsonKey(fromJson: _toDouble) final double monthlyIncome,
    @JsonKey(fromJson: _toDouble) final double monthlyExpenses,
    @JsonKey(fromJson: _toDouble) final double monthlyIncomePrimary,
    @JsonKey(fromJson: _toDouble) final double monthlyExpensesPrimary,
    @JsonKey(fromJson: _toDoubleOrNull) final double? projectedIncome,
    @JsonKey(fromJson: _toDoubleOrNull) final double? projectedExpenses,
    @JsonKey(fromJson: _toDoubleOrNull) final double? projectedIncomePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) final double? projectedExpensesPrimary,
    final int accountsCount,
    final int pendingCategorization,
    @JsonKey(fromJson: _toDouble) final double pendingCategorizationAmount,
    @JsonKey(fromJson: _toCurrencyMap) final Map<String, double> assetsValue,
    @JsonKey(fromJson: _toDouble) final double assetsValuePrimary,
    final String primaryCurrency,
    @JsonKey(fromJson: _toDouble) final double pendingSharesNet,
  }) = _$DashboardSummaryImpl;

  factory _DashboardSummary.fromJson(Map<String, dynamic> json) =
      _$DashboardSummaryImpl.fromJson;

  @override
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get totalBalance;
  @override
  @JsonKey(fromJson: _toDouble)
  double get totalBalancePrimary;
  @override
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get projectedBalance;
  @override
  @JsonKey(fromJson: _toDouble)
  double get projectedBalancePrimary;
  @override
  String? get balanceDate;
  @override
  @JsonKey(fromJson: _toDouble)
  double get monthlyIncome;
  @override
  @JsonKey(fromJson: _toDouble)
  double get monthlyExpenses;
  @override
  @JsonKey(fromJson: _toDouble)
  double get monthlyIncomePrimary;
  @override
  @JsonKey(fromJson: _toDouble)
  double get monthlyExpensesPrimary;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get projectedIncome;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get projectedExpenses;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get projectedIncomePrimary;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get projectedExpensesPrimary;
  @override
  int get accountsCount;
  @override
  int get pendingCategorization;
  @override
  @JsonKey(fromJson: _toDouble)
  double get pendingCategorizationAmount;
  @override
  @JsonKey(fromJson: _toCurrencyMap)
  Map<String, double> get assetsValue;
  @override
  @JsonKey(fromJson: _toDouble)
  double get assetsValuePrimary;
  @override
  String get primaryCurrency;

  /// Net pending balance from group splits, in the primary currency.
  /// Negative = net liability, positive = net receivable. Already accounts
  /// for partial settlements.
  @override
  @JsonKey(fromJson: _toDouble)
  double get pendingSharesNet;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardSummaryImplCopyWith<_$DashboardSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpendingByCategory _$SpendingByCategoryFromJson(Map<String, dynamic> json) {
  return _SpendingByCategory.fromJson(json);
}

/// @nodoc
mixin _$SpendingByCategory {
  String? get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get categoryIcon => throw _privateConstructorUsedError;
  String get categoryColor => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get total => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this SpendingByCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpendingByCategoryCopyWith<SpendingByCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpendingByCategoryCopyWith<$Res> {
  factory $SpendingByCategoryCopyWith(
    SpendingByCategory value,
    $Res Function(SpendingByCategory) then,
  ) = _$SpendingByCategoryCopyWithImpl<$Res, SpendingByCategory>;
  @useResult
  $Res call({
    String? categoryId,
    String categoryName,
    String categoryIcon,
    String categoryColor,
    @JsonKey(fromJson: _toDouble) double total,
    @JsonKey(fromJson: _toDouble) double percentage,
  });
}

/// @nodoc
class _$SpendingByCategoryCopyWithImpl<$Res, $Val extends SpendingByCategory>
    implements $SpendingByCategoryCopyWith<$Res> {
  _$SpendingByCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = freezed,
    Object? categoryName = null,
    Object? categoryIcon = null,
    Object? categoryColor = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(
      _value.copyWith(
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryIcon: null == categoryIcon
                ? _value.categoryIcon
                : categoryIcon // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryColor: null == categoryColor
                ? _value.categoryColor
                : categoryColor // ignore: cast_nullable_to_non_nullable
                      as String,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            percentage: null == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpendingByCategoryImplCopyWith<$Res>
    implements $SpendingByCategoryCopyWith<$Res> {
  factory _$$SpendingByCategoryImplCopyWith(
    _$SpendingByCategoryImpl value,
    $Res Function(_$SpendingByCategoryImpl) then,
  ) = __$$SpendingByCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? categoryId,
    String categoryName,
    String categoryIcon,
    String categoryColor,
    @JsonKey(fromJson: _toDouble) double total,
    @JsonKey(fromJson: _toDouble) double percentage,
  });
}

/// @nodoc
class __$$SpendingByCategoryImplCopyWithImpl<$Res>
    extends _$SpendingByCategoryCopyWithImpl<$Res, _$SpendingByCategoryImpl>
    implements _$$SpendingByCategoryImplCopyWith<$Res> {
  __$$SpendingByCategoryImplCopyWithImpl(
    _$SpendingByCategoryImpl _value,
    $Res Function(_$SpendingByCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = freezed,
    Object? categoryName = null,
    Object? categoryIcon = null,
    Object? categoryColor = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(
      _$SpendingByCategoryImpl(
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryIcon: null == categoryIcon
            ? _value.categoryIcon
            : categoryIcon // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryColor: null == categoryColor
            ? _value.categoryColor
            : categoryColor // ignore: cast_nullable_to_non_nullable
                  as String,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        percentage: null == percentage
            ? _value.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpendingByCategoryImpl implements _SpendingByCategory {
  const _$SpendingByCategoryImpl({
    this.categoryId,
    required this.categoryName,
    this.categoryIcon = '',
    this.categoryColor = '',
    @JsonKey(fromJson: _toDouble) this.total = 0,
    @JsonKey(fromJson: _toDouble) this.percentage = 0,
  });

  factory _$SpendingByCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpendingByCategoryImplFromJson(json);

  @override
  final String? categoryId;
  @override
  final String categoryName;
  @override
  @JsonKey()
  final String categoryIcon;
  @override
  @JsonKey()
  final String categoryColor;
  @override
  @JsonKey(fromJson: _toDouble)
  final double total;
  @override
  @JsonKey(fromJson: _toDouble)
  final double percentage;

  @override
  String toString() {
    return 'SpendingByCategory(categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, categoryColor: $categoryColor, total: $total, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpendingByCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.categoryIcon, categoryIcon) ||
                other.categoryIcon == categoryIcon) &&
            (identical(other.categoryColor, categoryColor) ||
                other.categoryColor == categoryColor) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryId,
    categoryName,
    categoryIcon,
    categoryColor,
    total,
    percentage,
  );

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpendingByCategoryImplCopyWith<_$SpendingByCategoryImpl> get copyWith =>
      __$$SpendingByCategoryImplCopyWithImpl<_$SpendingByCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpendingByCategoryImplToJson(this);
  }
}

abstract class _SpendingByCategory implements SpendingByCategory {
  const factory _SpendingByCategory({
    final String? categoryId,
    required final String categoryName,
    final String categoryIcon,
    final String categoryColor,
    @JsonKey(fromJson: _toDouble) final double total,
    @JsonKey(fromJson: _toDouble) final double percentage,
  }) = _$SpendingByCategoryImpl;

  factory _SpendingByCategory.fromJson(Map<String, dynamic> json) =
      _$SpendingByCategoryImpl.fromJson;

  @override
  String? get categoryId;
  @override
  String get categoryName;
  @override
  String get categoryIcon;
  @override
  String get categoryColor;
  @override
  @JsonKey(fromJson: _toDouble)
  double get total;
  @override
  @JsonKey(fromJson: _toDouble)
  double get percentage;

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpendingByCategoryImplCopyWith<_$SpendingByCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyTrend _$MonthlyTrendFromJson(Map<String, dynamic> json) {
  return _MonthlyTrend.fromJson(json);
}

/// @nodoc
mixin _$MonthlyTrend {
  String get month => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get income => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get expenses => throw _privateConstructorUsedError;

  /// Serializes this MonthlyTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyTrendCopyWith<MonthlyTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyTrendCopyWith<$Res> {
  factory $MonthlyTrendCopyWith(
    MonthlyTrend value,
    $Res Function(MonthlyTrend) then,
  ) = _$MonthlyTrendCopyWithImpl<$Res, MonthlyTrend>;
  @useResult
  $Res call({
    String month,
    @JsonKey(fromJson: _toDouble) double income,
    @JsonKey(fromJson: _toDouble) double expenses,
  });
}

/// @nodoc
class _$MonthlyTrendCopyWithImpl<$Res, $Val extends MonthlyTrend>
    implements $MonthlyTrendCopyWith<$Res> {
  _$MonthlyTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? income = null,
    Object? expenses = null,
  }) {
    return _then(
      _value.copyWith(
            month: null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as String,
            income: null == income
                ? _value.income
                : income // ignore: cast_nullable_to_non_nullable
                      as double,
            expenses: null == expenses
                ? _value.expenses
                : expenses // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MonthlyTrendImplCopyWith<$Res>
    implements $MonthlyTrendCopyWith<$Res> {
  factory _$$MonthlyTrendImplCopyWith(
    _$MonthlyTrendImpl value,
    $Res Function(_$MonthlyTrendImpl) then,
  ) = __$$MonthlyTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String month,
    @JsonKey(fromJson: _toDouble) double income,
    @JsonKey(fromJson: _toDouble) double expenses,
  });
}

/// @nodoc
class __$$MonthlyTrendImplCopyWithImpl<$Res>
    extends _$MonthlyTrendCopyWithImpl<$Res, _$MonthlyTrendImpl>
    implements _$$MonthlyTrendImplCopyWith<$Res> {
  __$$MonthlyTrendImplCopyWithImpl(
    _$MonthlyTrendImpl _value,
    $Res Function(_$MonthlyTrendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? income = null,
    Object? expenses = null,
  }) {
    return _then(
      _$MonthlyTrendImpl(
        month: null == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as String,
        income: null == income
            ? _value.income
            : income // ignore: cast_nullable_to_non_nullable
                  as double,
        expenses: null == expenses
            ? _value.expenses
            : expenses // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyTrendImpl implements _MonthlyTrend {
  const _$MonthlyTrendImpl({
    required this.month,
    @JsonKey(fromJson: _toDouble) this.income = 0,
    @JsonKey(fromJson: _toDouble) this.expenses = 0,
  });

  factory _$MonthlyTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyTrendImplFromJson(json);

  @override
  final String month;
  @override
  @JsonKey(fromJson: _toDouble)
  final double income;
  @override
  @JsonKey(fromJson: _toDouble)
  final double expenses;

  @override
  String toString() {
    return 'MonthlyTrend(month: $month, income: $income, expenses: $expenses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyTrendImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, month, income, expenses);

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyTrendImplCopyWith<_$MonthlyTrendImpl> get copyWith =>
      __$$MonthlyTrendImplCopyWithImpl<_$MonthlyTrendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyTrendImplToJson(this);
  }
}

abstract class _MonthlyTrend implements MonthlyTrend {
  const factory _MonthlyTrend({
    required final String month,
    @JsonKey(fromJson: _toDouble) final double income,
    @JsonKey(fromJson: _toDouble) final double expenses,
  }) = _$MonthlyTrendImpl;

  factory _MonthlyTrend.fromJson(Map<String, dynamic> json) =
      _$MonthlyTrendImpl.fromJson;

  @override
  String get month;
  @override
  @JsonKey(fromJson: _toDouble)
  double get income;
  @override
  @JsonKey(fromJson: _toDouble)
  double get expenses;

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyTrendImplCopyWith<_$MonthlyTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyBalance _$DailyBalanceFromJson(Map<String, dynamic> json) {
  return _DailyBalance.fromJson(json);
}

/// @nodoc
mixin _$DailyBalance {
  int get day => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get balance => throw _privateConstructorUsedError;

  /// Serializes this DailyBalance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyBalanceCopyWith<DailyBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyBalanceCopyWith<$Res> {
  factory $DailyBalanceCopyWith(
    DailyBalance value,
    $Res Function(DailyBalance) then,
  ) = _$DailyBalanceCopyWithImpl<$Res, DailyBalance>;
  @useResult
  $Res call({int day, @JsonKey(fromJson: _toDoubleOrNull) double? balance});
}

/// @nodoc
class _$DailyBalanceCopyWithImpl<$Res, $Val extends DailyBalance>
    implements $DailyBalanceCopyWith<$Res> {
  _$DailyBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? day = null, Object? balance = freezed}) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            balance: freezed == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyBalanceImplCopyWith<$Res>
    implements $DailyBalanceCopyWith<$Res> {
  factory _$$DailyBalanceImplCopyWith(
    _$DailyBalanceImpl value,
    $Res Function(_$DailyBalanceImpl) then,
  ) = __$$DailyBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int day, @JsonKey(fromJson: _toDoubleOrNull) double? balance});
}

/// @nodoc
class __$$DailyBalanceImplCopyWithImpl<$Res>
    extends _$DailyBalanceCopyWithImpl<$Res, _$DailyBalanceImpl>
    implements _$$DailyBalanceImplCopyWith<$Res> {
  __$$DailyBalanceImplCopyWithImpl(
    _$DailyBalanceImpl _value,
    $Res Function(_$DailyBalanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? day = null, Object? balance = freezed}) {
    return _then(
      _$DailyBalanceImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        balance: freezed == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyBalanceImpl implements _DailyBalance {
  const _$DailyBalanceImpl({
    required this.day,
    @JsonKey(fromJson: _toDoubleOrNull) this.balance,
  });

  factory _$DailyBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyBalanceImplFromJson(json);

  @override
  final int day;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? balance;

  @override
  String toString() {
    return 'DailyBalance(day: $day, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyBalanceImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, day, balance);

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyBalanceImplCopyWith<_$DailyBalanceImpl> get copyWith =>
      __$$DailyBalanceImplCopyWithImpl<_$DailyBalanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyBalanceImplToJson(this);
  }
}

abstract class _DailyBalance implements DailyBalance {
  const factory _DailyBalance({
    required final int day,
    @JsonKey(fromJson: _toDoubleOrNull) final double? balance,
  }) = _$DailyBalanceImpl;

  factory _DailyBalance.fromJson(Map<String, dynamic> json) =
      _$DailyBalanceImpl.fromJson;

  @override
  int get day;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get balance;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyBalanceImplCopyWith<_$DailyBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BalanceHistory _$BalanceHistoryFromJson(Map<String, dynamic> json) {
  return _BalanceHistory.fromJson(json);
}

/// @nodoc
mixin _$BalanceHistory {
  List<DailyBalance> get current => throw _privateConstructorUsedError;
  List<DailyBalance> get previous => throw _privateConstructorUsedError;

  /// Serializes this BalanceHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BalanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BalanceHistoryCopyWith<BalanceHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceHistoryCopyWith<$Res> {
  factory $BalanceHistoryCopyWith(
    BalanceHistory value,
    $Res Function(BalanceHistory) then,
  ) = _$BalanceHistoryCopyWithImpl<$Res, BalanceHistory>;
  @useResult
  $Res call({List<DailyBalance> current, List<DailyBalance> previous});
}

/// @nodoc
class _$BalanceHistoryCopyWithImpl<$Res, $Val extends BalanceHistory>
    implements $BalanceHistoryCopyWith<$Res> {
  _$BalanceHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BalanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null, Object? previous = null}) {
    return _then(
      _value.copyWith(
            current: null == current
                ? _value.current
                : current // ignore: cast_nullable_to_non_nullable
                      as List<DailyBalance>,
            previous: null == previous
                ? _value.previous
                : previous // ignore: cast_nullable_to_non_nullable
                      as List<DailyBalance>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BalanceHistoryImplCopyWith<$Res>
    implements $BalanceHistoryCopyWith<$Res> {
  factory _$$BalanceHistoryImplCopyWith(
    _$BalanceHistoryImpl value,
    $Res Function(_$BalanceHistoryImpl) then,
  ) = __$$BalanceHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DailyBalance> current, List<DailyBalance> previous});
}

/// @nodoc
class __$$BalanceHistoryImplCopyWithImpl<$Res>
    extends _$BalanceHistoryCopyWithImpl<$Res, _$BalanceHistoryImpl>
    implements _$$BalanceHistoryImplCopyWith<$Res> {
  __$$BalanceHistoryImplCopyWithImpl(
    _$BalanceHistoryImpl _value,
    $Res Function(_$BalanceHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BalanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null, Object? previous = null}) {
    return _then(
      _$BalanceHistoryImpl(
        current: null == current
            ? _value._current
            : current // ignore: cast_nullable_to_non_nullable
                  as List<DailyBalance>,
        previous: null == previous
            ? _value._previous
            : previous // ignore: cast_nullable_to_non_nullable
                  as List<DailyBalance>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BalanceHistoryImpl implements _BalanceHistory {
  const _$BalanceHistoryImpl({
    final List<DailyBalance> current = const <DailyBalance>[],
    final List<DailyBalance> previous = const <DailyBalance>[],
  }) : _current = current,
       _previous = previous;

  factory _$BalanceHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BalanceHistoryImplFromJson(json);

  final List<DailyBalance> _current;
  @override
  @JsonKey()
  List<DailyBalance> get current {
    if (_current is EqualUnmodifiableListView) return _current;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_current);
  }

  final List<DailyBalance> _previous;
  @override
  @JsonKey()
  List<DailyBalance> get previous {
    if (_previous is EqualUnmodifiableListView) return _previous;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previous);
  }

  @override
  String toString() {
    return 'BalanceHistory(current: $current, previous: $previous)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceHistoryImpl &&
            const DeepCollectionEquality().equals(other._current, _current) &&
            const DeepCollectionEquality().equals(other._previous, _previous));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_current),
    const DeepCollectionEquality().hash(_previous),
  );

  /// Create a copy of BalanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceHistoryImplCopyWith<_$BalanceHistoryImpl> get copyWith =>
      __$$BalanceHistoryImplCopyWithImpl<_$BalanceHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BalanceHistoryImplToJson(this);
  }
}

abstract class _BalanceHistory implements BalanceHistory {
  const factory _BalanceHistory({
    final List<DailyBalance> current,
    final List<DailyBalance> previous,
  }) = _$BalanceHistoryImpl;

  factory _BalanceHistory.fromJson(Map<String, dynamic> json) =
      _$BalanceHistoryImpl.fromJson;

  @override
  List<DailyBalance> get current;
  @override
  List<DailyBalance> get previous;

  /// Create a copy of BalanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BalanceHistoryImplCopyWith<_$BalanceHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
