import 'package:freezed_annotation/freezed_annotation.dart';

import 'category.dart';
import 'json.dart';

part 'payee.freezed.dart';
part 'payee.g.dart';

@freezed
class PayeeTaxId with _$PayeeTaxId {
  const factory PayeeTaxId({
    required String kind,
    required String value,
  }) = _PayeeTaxId;

  factory PayeeTaxId.fromJson(Map<String, dynamic> json) =>
      _$PayeeTaxIdFromJson(json);
}

@freezed
class Payee with _$Payee {
  const factory Payee({
    required String id,
    required String name,

    /// Legal nature, or null when unknown — the normal state for a row sync
    /// created.
    String? type,

    /// Where the row came from. Server-set at creation and never editable.
    @Default('manual') String source,
    @Default(false) bool isFavorite,
    String? notes,
    String? email,
    String? phone,
    String? address,
    String? website,
    @Default(<PayeeTaxId>[]) List<PayeeTaxId> taxIds,
    String? createdAt,
    @Default(0) int transactionCount,
  }) = _Payee;

  factory Payee.fromJson(Map<String, dynamic> json) => _$PayeeFromJson(json);
}

@freezed
class PayeeSummary with _$PayeeSummary {
  const factory PayeeSummary({
    required Payee payee,
    @JsonKey(fromJson: toDouble) @Default(0) double totalSpent,
    @JsonKey(fromJson: toDouble) @Default(0) double totalReceived,
    @Default(0) int transactionCount,
    Category? mostCommonCategory,
    String? lastTransactionDate,
  }) = _PayeeSummary;

  factory PayeeSummary.fromJson(Map<String, dynamic> json) =>
      _$PayeeSummaryFromJson(json);
}
