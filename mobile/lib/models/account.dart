import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

double? _toDoubleOrNull(Object? value) =>
    value == null ? null : _toDouble(value);

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required String type,
    @JsonKey(fromJson: _toDouble) @Default(0) double balance,
    @Default('USD') String currency,
    String? displayName,
    String? maskedNumber,
    String? institutionName,
    String? institutionLogoUrl,
    @JsonKey(fromJson: _toDouble) @Default(0) double currentBalance,
    @JsonKey(fromJson: _toDoubleOrNull) double? balancePrimary,
    @JsonKey(fromJson: _toDoubleOrNull) double? creditLimit,
    @JsonKey(fromJson: _toDoubleOrNull) double? availableCredit,
    String? nextDueDate,
    @JsonKey(fromJson: _toDoubleOrNull) double? minimumPayment,
    @Default(false) bool isClosed,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  const Account._();

  /// What the list shows: the user's override if they set one, else the name
  /// the provider (or the user, for a manual account) gave it.
  String get label => displayName?.trim().isNotEmpty == true
      ? displayName!
      : name;
}
