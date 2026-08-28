// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      balance: json['balance'] == null ? 0 : _toDouble(json['balance']),
      currency: json['currency'] as String? ?? 'USD',
      displayName: json['display_name'] as String?,
      maskedNumber: json['masked_number'] as String?,
      institutionName: json['institution_name'] as String?,
      institutionLogoUrl: json['institution_logo_url'] as String?,
      currentBalance: json['current_balance'] == null
          ? 0
          : _toDouble(json['current_balance']),
      balancePrimary: _toDoubleOrNull(json['balance_primary']),
      creditLimit: _toDoubleOrNull(json['credit_limit']),
      availableCredit: _toDoubleOrNull(json['available_credit']),
      nextDueDate: json['next_due_date'] as String?,
      minimumPayment: _toDoubleOrNull(json['minimum_payment']),
      isClosed: json['is_closed'] as bool? ?? false,
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'balance': instance.balance,
      'currency': instance.currency,
      'display_name': instance.displayName,
      'masked_number': instance.maskedNumber,
      'institution_name': instance.institutionName,
      'institution_logo_url': instance.institutionLogoUrl,
      'current_balance': instance.currentBalance,
      'balance_primary': instance.balancePrimary,
      'credit_limit': instance.creditLimit,
      'available_credit': instance.availableCredit,
      'next_due_date': instance.nextDueDate,
      'minimum_payment': instance.minimumPayment,
      'is_closed': instance.isClosed,
    };
