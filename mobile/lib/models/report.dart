import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

@freezed
class ReportDataPoint with _$ReportDataPoint {
  const factory ReportDataPoint({
    required String date,
    @JsonKey(fromJson: _toDouble) @Default(0) double value,
  }) = _ReportDataPoint;

  factory ReportDataPoint.fromJson(Map<String, dynamic> json) =>
      _$ReportDataPointFromJson(json);
}

@freezed
class ReportBreakdown with _$ReportBreakdown {
  const factory ReportBreakdown({
    required String key,
    required String label,
    @JsonKey(fromJson: _toDouble) @Default(0) double value,
    @Default('') String color,
  }) = _ReportBreakdown;

  factory ReportBreakdown.fromJson(Map<String, dynamic> json) =>
      _$ReportBreakdownFromJson(json);
}

@freezed
class ReportSummary with _$ReportSummary {
  const factory ReportSummary({
    @JsonKey(fromJson: _toDouble) @Default(0) double primaryValue,
    @JsonKey(fromJson: _toDouble) @Default(0) double changeAmount,
    double? changePercent,
    @Default(<ReportBreakdown>[]) List<ReportBreakdown> breakdowns,
  }) = _ReportSummary;

  factory ReportSummary.fromJson(Map<String, dynamic> json) =>
      _$ReportSummaryFromJson(json);
}

@freezed
class ReportMeta with _$ReportMeta {
  const factory ReportMeta({
    required String type,
    @Default('USD') String currency,
    @Default('monthly') String interval,
  }) = _ReportMeta;

  factory ReportMeta.fromJson(Map<String, dynamic> json) =>
      _$ReportMetaFromJson(json);
}

@freezed
class Report with _$Report {
  const factory Report({
    required ReportSummary summary,
    @Default(<ReportDataPoint>[]) List<ReportDataPoint> trend,
    required ReportMeta meta,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
