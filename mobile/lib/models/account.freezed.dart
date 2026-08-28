// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get balance => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get maskedNumber => throw _privateConstructorUsedError;
  String? get institutionName => throw _privateConstructorUsedError;
  String? get institutionLogoUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get currentBalance => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get balancePrimary => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get creditLimit => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get availableCredit => throw _privateConstructorUsedError;
  String? get nextDueDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get minimumPayment => throw _privateConstructorUsedError;
  bool get isClosed => throw _privateConstructorUsedError;

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call({
    String id,
    String name,
    String type,
    @JsonKey(fromJson: _toDouble) double balance,
    String currency,
    String? displayName,
    String? maskedNumber,
    String? institutionName,
    String? institutionLogoUrl,
    @JsonKey(fromJson: _toDouble) double currentBalance,
    @JsonKey(fromJson: _toDoubleOrNull) double? balancePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? creditLimit,
    @JsonKey(fromJson: _toDoubleOrNull) double? availableCredit,
    String? nextDueDate,
    @JsonKey(fromJson: _toDoubleOrNull) double? minimumPayment,
    bool isClosed,
  });
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? balance = null,
    Object? currency = null,
    Object? displayName = freezed,
    Object? maskedNumber = freezed,
    Object? institutionName = freezed,
    Object? institutionLogoUrl = freezed,
    Object? currentBalance = null,
    Object? balancePrimary = freezed,
    Object? creditLimit = freezed,
    Object? availableCredit = freezed,
    Object? nextDueDate = freezed,
    Object? minimumPayment = freezed,
    Object? isClosed = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            maskedNumber: freezed == maskedNumber
                ? _value.maskedNumber
                : maskedNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            institutionName: freezed == institutionName
                ? _value.institutionName
                : institutionName // ignore: cast_nullable_to_non_nullable
                      as String?,
            institutionLogoUrl: freezed == institutionLogoUrl
                ? _value.institutionLogoUrl
                : institutionLogoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentBalance: null == currentBalance
                ? _value.currentBalance
                : currentBalance // ignore: cast_nullable_to_non_nullable
                      as double,
            balancePrimary: freezed == balancePrimary
                ? _value.balancePrimary
                : balancePrimary // ignore: cast_nullable_to_non_nullable
                      as double?,
            creditLimit: freezed == creditLimit
                ? _value.creditLimit
                : creditLimit // ignore: cast_nullable_to_non_nullable
                      as double?,
            availableCredit: freezed == availableCredit
                ? _value.availableCredit
                : availableCredit // ignore: cast_nullable_to_non_nullable
                      as double?,
            nextDueDate: freezed == nextDueDate
                ? _value.nextDueDate
                : nextDueDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            minimumPayment: freezed == minimumPayment
                ? _value.minimumPayment
                : minimumPayment // ignore: cast_nullable_to_non_nullable
                      as double?,
            isClosed: null == isClosed
                ? _value.isClosed
                : isClosed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
    _$AccountImpl value,
    $Res Function(_$AccountImpl) then,
  ) = __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String type,
    @JsonKey(fromJson: _toDouble) double balance,
    String currency,
    String? displayName,
    String? maskedNumber,
    String? institutionName,
    String? institutionLogoUrl,
    @JsonKey(fromJson: _toDouble) double currentBalance,
    @JsonKey(fromJson: _toDoubleOrNull) double? balancePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? creditLimit,
    @JsonKey(fromJson: _toDoubleOrNull) double? availableCredit,
    String? nextDueDate,
    @JsonKey(fromJson: _toDoubleOrNull) double? minimumPayment,
    bool isClosed,
  });
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
    _$AccountImpl _value,
    $Res Function(_$AccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? balance = null,
    Object? currency = null,
    Object? displayName = freezed,
    Object? maskedNumber = freezed,
    Object? institutionName = freezed,
    Object? institutionLogoUrl = freezed,
    Object? currentBalance = null,
    Object? balancePrimary = freezed,
    Object? creditLimit = freezed,
    Object? availableCredit = freezed,
    Object? nextDueDate = freezed,
    Object? minimumPayment = freezed,
    Object? isClosed = null,
  }) {
    return _then(
      _$AccountImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        maskedNumber: freezed == maskedNumber
            ? _value.maskedNumber
            : maskedNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        institutionName: freezed == institutionName
            ? _value.institutionName
            : institutionName // ignore: cast_nullable_to_non_nullable
                  as String?,
        institutionLogoUrl: freezed == institutionLogoUrl
            ? _value.institutionLogoUrl
            : institutionLogoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentBalance: null == currentBalance
            ? _value.currentBalance
            : currentBalance // ignore: cast_nullable_to_non_nullable
                  as double,
        balancePrimary: freezed == balancePrimary
            ? _value.balancePrimary
            : balancePrimary // ignore: cast_nullable_to_non_nullable
                  as double?,
        creditLimit: freezed == creditLimit
            ? _value.creditLimit
            : creditLimit // ignore: cast_nullable_to_non_nullable
                  as double?,
        availableCredit: freezed == availableCredit
            ? _value.availableCredit
            : availableCredit // ignore: cast_nullable_to_non_nullable
                  as double?,
        nextDueDate: freezed == nextDueDate
            ? _value.nextDueDate
            : nextDueDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        minimumPayment: freezed == minimumPayment
            ? _value.minimumPayment
            : minimumPayment // ignore: cast_nullable_to_non_nullable
                  as double?,
        isClosed: null == isClosed
            ? _value.isClosed
            : isClosed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountImpl extends _Account {
  const _$AccountImpl({
    required this.id,
    required this.name,
    required this.type,
    @JsonKey(fromJson: _toDouble) this.balance = 0,
    this.currency = 'USD',
    this.displayName,
    this.maskedNumber,
    this.institutionName,
    this.institutionLogoUrl,
    @JsonKey(fromJson: _toDouble) this.currentBalance = 0,
    @JsonKey(fromJson: _toDoubleOrNull) this.balancePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) this.creditLimit,
    @JsonKey(fromJson: _toDoubleOrNull) this.availableCredit,
    this.nextDueDate,
    @JsonKey(fromJson: _toDoubleOrNull) this.minimumPayment,
    this.isClosed = false,
  }) : super._();

  factory _$AccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  @JsonKey(fromJson: _toDouble)
  final double balance;
  @override
  @JsonKey()
  final String currency;
  @override
  final String? displayName;
  @override
  final String? maskedNumber;
  @override
  final String? institutionName;
  @override
  final String? institutionLogoUrl;
  @override
  @JsonKey(fromJson: _toDouble)
  final double currentBalance;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? balancePrimary;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? creditLimit;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? availableCredit;
  @override
  final String? nextDueDate;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  final double? minimumPayment;
  @override
  @JsonKey()
  final bool isClosed;

  @override
  String toString() {
    return 'Account(id: $id, name: $name, type: $type, balance: $balance, currency: $currency, displayName: $displayName, maskedNumber: $maskedNumber, institutionName: $institutionName, institutionLogoUrl: $institutionLogoUrl, currentBalance: $currentBalance, balancePrimary: $balancePrimary, creditLimit: $creditLimit, availableCredit: $availableCredit, nextDueDate: $nextDueDate, minimumPayment: $minimumPayment, isClosed: $isClosed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.maskedNumber, maskedNumber) ||
                other.maskedNumber == maskedNumber) &&
            (identical(other.institutionName, institutionName) ||
                other.institutionName == institutionName) &&
            (identical(other.institutionLogoUrl, institutionLogoUrl) ||
                other.institutionLogoUrl == institutionLogoUrl) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance) &&
            (identical(other.balancePrimary, balancePrimary) ||
                other.balancePrimary == balancePrimary) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.availableCredit, availableCredit) ||
                other.availableCredit == availableCredit) &&
            (identical(other.nextDueDate, nextDueDate) ||
                other.nextDueDate == nextDueDate) &&
            (identical(other.minimumPayment, minimumPayment) ||
                other.minimumPayment == minimumPayment) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    balance,
    currency,
    displayName,
    maskedNumber,
    institutionName,
    institutionLogoUrl,
    currentBalance,
    balancePrimary,
    creditLimit,
    availableCredit,
    nextDueDate,
    minimumPayment,
    isClosed,
  );

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountImplToJson(this);
  }
}

abstract class _Account extends Account {
  const factory _Account({
    required final String id,
    required final String name,
    required final String type,
    @JsonKey(fromJson: _toDouble) final double balance,
    final String currency,
    final String? displayName,
    final String? maskedNumber,
    final String? institutionName,
    final String? institutionLogoUrl,
    @JsonKey(fromJson: _toDouble) final double currentBalance,
    @JsonKey(fromJson: _toDoubleOrNull) final double? balancePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) final double? creditLimit,
    @JsonKey(fromJson: _toDoubleOrNull) final double? availableCredit,
    final String? nextDueDate,
    @JsonKey(fromJson: _toDoubleOrNull) final double? minimumPayment,
    final bool isClosed,
  }) = _$AccountImpl;
  const _Account._() : super._();

  factory _Account.fromJson(Map<String, dynamic> json) = _$AccountImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  @JsonKey(fromJson: _toDouble)
  double get balance;
  @override
  String get currency;
  @override
  String? get displayName;
  @override
  String? get maskedNumber;
  @override
  String? get institutionName;
  @override
  String? get institutionLogoUrl;
  @override
  @JsonKey(fromJson: _toDouble)
  double get currentBalance;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get balancePrimary;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get creditLimit;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get availableCredit;
  @override
  String? get nextDueDate;
  @override
  @JsonKey(fromJson: _toDoubleOrNull)
  double? get minimumPayment;
  @override
  bool get isClosed;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
