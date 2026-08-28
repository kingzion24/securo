import 'package:freezed_annotation/freezed_annotation.dart';

import 'category.dart';
import 'json.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

enum TransactionType {
  @JsonValue('debit')
  debit,
  @JsonValue('credit')
  credit,
}

enum TransactionStatus {
  @JsonValue('posted')
  posted,
  @JsonValue('pending')
  pending,
}

/// Scope for installment-series edits and deletes. `this` only touches the
/// target row, `future` it plus later installments, `all` the whole series.
/// Ignored server-side for non-installment transactions.
enum TransactionApplyScope {
  @JsonValue('this')
  thisOne,
  @JsonValue('future')
  future,
  @JsonValue('all')
  all;

  String get wire => switch (this) {
        TransactionApplyScope.thisOne => 'this',
        TransactionApplyScope.future => 'future',
        TransactionApplyScope.all => 'all',
      };
}

@freezed
class TransactionSplit with _$TransactionSplit {
  const factory TransactionSplit({
    required String id,
    required String transactionId,
    required String groupMemberId,
    @JsonKey(fromJson: toDouble) @Default(0) double shareAmount,
    @Default('equal') String shareType,
    @JsonKey(fromJson: toDoubleOrNull) double? sharePct,
    String? notes,
    String? createdAt,
  }) = _TransactionSplit;

  factory TransactionSplit.fromJson(Map<String, dynamic> json) =>
      _$TransactionSplitFromJson(json);
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    String? accountId,
    String? categoryId,
    Category? category,
    String? externalId,
    @Default('') String description,
    String? originalDescription,
    @JsonKey(fromJson: toDouble) @Default(0) double amount,
    @Default('USD') String currency,
    required String date,
    @Default(TransactionType.debit) TransactionType type,
    @Default('') String source,
    @Default(TransactionStatus.posted) TransactionStatus status,
    String? payee,
    String? payeeId,
    String? payeeName,
    String? notes,

    /// Set on both halves of a transfer, so the pair can be shown as one move
    /// rather than two unrelated rows.
    String? transferPairId,
    @JsonKey(fromJson: toDoubleOrNull) double? amountPrimary,
    @JsonKey(fromJson: toDoubleOrNull) double? fxRateUsed,
    @Default(false) bool fxFallback,
    @Default(0) int attachmentCount,
    int? installmentNumber,
    int? totalInstallments,
    @JsonKey(fromJson: toDoubleOrNull) double? installmentTotalAmount,
    String? installmentPurchaseDate,
    String? installmentSeriesId,
    String? billId,

    /// Manual override for which credit-card bill cycle this belongs to.
    /// Null means auto bucketing.
    String? effectiveBillDate,
    String? recurringTransactionId,
    @Default(<TransactionSplit>[]) List<TransactionSplit> splits,

    /// Shared-transaction view fields, set per-request when the viewer is a
    /// linked split member but not the owner. Render [viewerShare] as the
    /// amount and treat the row as read-only — editing belongs to the
    /// parent's owner.
    @Default(false) bool isShared,
    @JsonKey(fromJson: toDoubleOrNull) double? viewerShare,
    String? groupId,
    String? parentOwnerName,

    /// Excluded from reports and dashboard aggregations.
    @Default(false) bool isIgnored,
    /// Named `isVirtual` rather than `virtual` because the latter resolves to
    /// the `meta` package's annotation of that name inside expressions.
    @JsonKey(name: 'virtual') @Default(false) bool isVirtual,
  }) = _Transaction;

  const Transaction._();

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  /// Credits add, debits subtract. The API stores the magnitude in [amount]
  /// and the direction in [type], so a signed value has to be derived.
  double get signedAmount =>
      type == TransactionType.credit ? amount.abs() : -amount.abs();

  /// What to show as the amount. A viewer looking at someone else's shared
  /// transaction sees their own share, not the full sum.
  double get displayAmount {
    if (isShared && viewerShare != null) {
      return type == TransactionType.credit
          ? viewerShare!.abs()
          : -viewerShare!.abs();
    }
    return signedAmount;
  }

  /// Shared rows belong to whoever paid; the viewer cannot edit them.
  bool get isEditable => !isShared && !isVirtual;

  bool get isInstallment =>
      installmentNumber != null && totalInstallments != null;

  String get title {
    if (payeeName != null && payeeName!.trim().isNotEmpty) return payeeName!;
    if (description.trim().isNotEmpty) return description;
    return originalDescription ?? 'Transaction';
  }
}

/// Income / expense / net totals for every transaction matching the active
/// filters. It accompanies the paginated response rather than being derived
/// from the current page, so the figures describe the whole filtered set.
@freezed
class TransactionsSummary with _$TransactionsSummary {
  const factory TransactionsSummary({
    @JsonKey(fromJson: toDouble) @Default(0) double income,
    @JsonKey(fromJson: toDouble) @Default(0) double expense,
    @JsonKey(fromJson: toDouble) @Default(0) double net,

    /// Absolute total of everything excluded from income/expense for the same
    /// rows — transfers, treat-as-transfer categories and ignored items.
    @JsonKey(fromJson: toDouble) @Default(0) double excluded,
    @Default('USD') String currency,
  }) = _TransactionsSummary;

  factory TransactionsSummary.fromJson(Map<String, dynamic> json) =>
      _$TransactionsSummaryFromJson(json);
}

/// `GET /api/transactions` response envelope.
@freezed
class PaginatedTransactions with _$PaginatedTransactions {
  const factory PaginatedTransactions({
    @Default(<Transaction>[]) List<Transaction> items,
    @Default(0) int total,
    @Default(1) int page,

    /// Named `limit` on the wire, matching `PaginatedResponse<T>` on the web.
    @Default(50) int limit,
    TransactionsSummary? summary,
  }) = _PaginatedTransactions;

  const PaginatedTransactions._();

  factory PaginatedTransactions.fromJson(Map<String, dynamic> json) =>
      _$PaginatedTransactionsFromJson(json);

  /// Pages are 1-based, so `page * limit` is how many rows are already loaded.
  bool get hasMore => page * limit < total;
}
