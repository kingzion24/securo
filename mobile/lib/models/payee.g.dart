// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayeeTaxIdImpl _$$PayeeTaxIdImplFromJson(Map<String, dynamic> json) =>
    _$PayeeTaxIdImpl(
      kind: json['kind'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$PayeeTaxIdImplToJson(_$PayeeTaxIdImpl instance) =>
    <String, dynamic>{'kind': instance.kind, 'value': instance.value};

_$PayeeImpl _$$PayeeImplFromJson(Map<String, dynamic> json) => _$PayeeImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String?,
  source: json['source'] as String? ?? 'manual',
  isFavorite: json['is_favorite'] as bool? ?? false,
  notes: json['notes'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  website: json['website'] as String?,
  taxIds:
      (json['tax_ids'] as List<dynamic>?)
          ?.map((e) => PayeeTaxId.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PayeeTaxId>[],
  createdAt: json['created_at'] as String?,
  transactionCount: (json['transaction_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PayeeImplToJson(_$PayeeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'source': instance.source,
      'is_favorite': instance.isFavorite,
      'notes': instance.notes,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'website': instance.website,
      'tax_ids': instance.taxIds.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt,
      'transaction_count': instance.transactionCount,
    };

_$PayeeSummaryImpl _$$PayeeSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$PayeeSummaryImpl(
  payee: Payee.fromJson(json['payee'] as Map<String, dynamic>),
  totalSpent: json['total_spent'] == null ? 0 : toDouble(json['total_spent']),
  totalReceived: json['total_received'] == null
      ? 0
      : toDouble(json['total_received']),
  transactionCount: (json['transaction_count'] as num?)?.toInt() ?? 0,
  mostCommonCategory: json['most_common_category'] == null
      ? null
      : Category.fromJson(json['most_common_category'] as Map<String, dynamic>),
  lastTransactionDate: json['last_transaction_date'] as String?,
);

Map<String, dynamic> _$$PayeeSummaryImplToJson(_$PayeeSummaryImpl instance) =>
    <String, dynamic>{
      'payee': instance.payee.toJson(),
      'total_spent': instance.totalSpent,
      'total_received': instance.totalReceived,
      'transaction_count': instance.transactionCount,
      'most_common_category': instance.mostCommonCategory?.toJson(),
      'last_transaction_date': instance.lastTransactionDate,
    };
