// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportDataPointImpl _$$ReportDataPointImplFromJson(
  Map<String, dynamic> json,
) => _$ReportDataPointImpl(
  date: json['date'] as String,
  value: json['value'] == null ? 0 : _toDouble(json['value']),
);

Map<String, dynamic> _$$ReportDataPointImplToJson(
  _$ReportDataPointImpl instance,
) => <String, dynamic>{'date': instance.date, 'value': instance.value};

_$ReportBreakdownImpl _$$ReportBreakdownImplFromJson(
  Map<String, dynamic> json,
) => _$ReportBreakdownImpl(
  key: json['key'] as String,
  label: json['label'] as String,
  value: json['value'] == null ? 0 : _toDouble(json['value']),
  color: json['color'] as String? ?? '',
);

Map<String, dynamic> _$$ReportBreakdownImplToJson(
  _$ReportBreakdownImpl instance,
) => <String, dynamic>{
  'key': instance.key,
  'label': instance.label,
  'value': instance.value,
  'color': instance.color,
};

_$ReportSummaryImpl _$$ReportSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ReportSummaryImpl(
      primaryValue: json['primary_value'] == null
          ? 0
          : _toDouble(json['primary_value']),
      changeAmount: json['change_amount'] == null
          ? 0
          : _toDouble(json['change_amount']),
      changePercent: (json['change_percent'] as num?)?.toDouble(),
      breakdowns:
          (json['breakdowns'] as List<dynamic>?)
              ?.map((e) => ReportBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReportBreakdown>[],
    );

Map<String, dynamic> _$$ReportSummaryImplToJson(_$ReportSummaryImpl instance) =>
    <String, dynamic>{
      'primary_value': instance.primaryValue,
      'change_amount': instance.changeAmount,
      'change_percent': instance.changePercent,
      'breakdowns': instance.breakdowns.map((e) => e.toJson()).toList(),
    };

_$ReportMetaImpl _$$ReportMetaImplFromJson(Map<String, dynamic> json) =>
    _$ReportMetaImpl(
      type: json['type'] as String,
      currency: json['currency'] as String? ?? 'USD',
      interval: json['interval'] as String? ?? 'monthly',
    );

Map<String, dynamic> _$$ReportMetaImplToJson(_$ReportMetaImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'currency': instance.currency,
      'interval': instance.interval,
    };

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
  summary: ReportSummary.fromJson(json['summary'] as Map<String, dynamic>),
  trend:
      (json['trend'] as List<dynamic>?)
          ?.map((e) => ReportDataPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ReportDataPoint>[],
  meta: ReportMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary.toJson(),
      'trend': instance.trend.map((e) => e.toJson()).toList(),
      'meta': instance.meta.toJson(),
    };
