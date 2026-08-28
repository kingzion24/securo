// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionSplitImpl _$$TransactionSplitImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionSplitImpl(
  id: json['id'] as String,
  transactionId: json['transaction_id'] as String,
  groupMemberId: json['group_member_id'] as String,
  shareAmount: json['share_amount'] == null
      ? 0
      : toDouble(json['share_amount']),
  shareType: json['share_type'] as String? ?? 'equal',
  sharePct: toDoubleOrNull(json['share_pct']),
  notes: json['notes'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$TransactionSplitImplToJson(
  _$TransactionSplitImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'transaction_id': instance.transactionId,
  'group_member_id': instance.groupMemberId,
  'share_amount': instance.shareAmount,
  'share_type': instance.shareType,
  'share_pct': instance.sharePct,
  'notes': instance.notes,
  'created_at': instance.createdAt,
};

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      accountId: json['account_id'] as String?,
      categoryId: json['category_id'] as String?,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      externalId: json['external_id'] as String?,
      description: json['description'] as String? ?? '',
      originalDescription: json['original_description'] as String?,
      amount: json['amount'] == null ? 0 : toDouble(json['amount']),
      currency: json['currency'] as String? ?? 'USD',
      date: json['date'] as String,
      type:
          $enumDecodeNullable(_$TransactionTypeEnumMap, json['type']) ??
          TransactionType.debit,
      source: json['source'] as String? ?? '',
      status:
          $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']) ??
          TransactionStatus.posted,
      payee: json['payee'] as String?,
      payeeId: json['payee_id'] as String?,
      payeeName: json['payee_name'] as String?,
      notes: json['notes'] as String?,
      transferPairId: json['transfer_pair_id'] as String?,
      amountPrimary: toDoubleOrNull(json['amount_primary']),
      fxRateUsed: toDoubleOrNull(json['fx_rate_used']),
      fxFallback: json['fx_fallback'] as bool? ?? false,
      attachmentCount: (json['attachment_count'] as num?)?.toInt() ?? 0,
      installmentNumber: (json['installment_number'] as num?)?.toInt(),
      totalInstallments: (json['total_installments'] as num?)?.toInt(),
      installmentTotalAmount: toDoubleOrNull(json['installment_total_amount']),
      installmentPurchaseDate: json['installment_purchase_date'] as String?,
      installmentSeriesId: json['installment_series_id'] as String?,
      billId: json['bill_id'] as String?,
      effectiveBillDate: json['effective_bill_date'] as String?,
      recurringTransactionId: json['recurring_transaction_id'] as String?,
      splits:
          (json['splits'] as List<dynamic>?)
              ?.map((e) => TransactionSplit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TransactionSplit>[],
      isShared: json['is_shared'] as bool? ?? false,
      viewerShare: toDoubleOrNull(json['viewer_share']),
      groupId: json['group_id'] as String?,
      parentOwnerName: json['parent_owner_name'] as String?,
      isIgnored: json['is_ignored'] as bool? ?? false,
      isVirtual: json['virtual'] as bool? ?? false,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'category_id': instance.categoryId,
      'category': instance.category?.toJson(),
      'external_id': instance.externalId,
      'description': instance.description,
      'original_description': instance.originalDescription,
      'amount': instance.amount,
      'currency': instance.currency,
      'date': instance.date,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'source': instance.source,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'payee': instance.payee,
      'payee_id': instance.payeeId,
      'payee_name': instance.payeeName,
      'notes': instance.notes,
      'transfer_pair_id': instance.transferPairId,
      'amount_primary': instance.amountPrimary,
      'fx_rate_used': instance.fxRateUsed,
      'fx_fallback': instance.fxFallback,
      'attachment_count': instance.attachmentCount,
      'installment_number': instance.installmentNumber,
      'total_installments': instance.totalInstallments,
      'installment_total_amount': instance.installmentTotalAmount,
      'installment_purchase_date': instance.installmentPurchaseDate,
      'installment_series_id': instance.installmentSeriesId,
      'bill_id': instance.billId,
      'effective_bill_date': instance.effectiveBillDate,
      'recurring_transaction_id': instance.recurringTransactionId,
      'splits': instance.splits.map((e) => e.toJson()).toList(),
      'is_shared': instance.isShared,
      'viewer_share': instance.viewerShare,
      'group_id': instance.groupId,
      'parent_owner_name': instance.parentOwnerName,
      'is_ignored': instance.isIgnored,
      'virtual': instance.isVirtual,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.debit: 'debit',
  TransactionType.credit: 'credit',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.posted: 'posted',
  TransactionStatus.pending: 'pending',
};

_$TransactionsSummaryImpl _$$TransactionsSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionsSummaryImpl(
  income: json['income'] == null ? 0 : toDouble(json['income']),
  expense: json['expense'] == null ? 0 : toDouble(json['expense']),
  net: json['net'] == null ? 0 : toDouble(json['net']),
  excluded: json['excluded'] == null ? 0 : toDouble(json['excluded']),
  currency: json['currency'] as String? ?? 'USD',
);

Map<String, dynamic> _$$TransactionsSummaryImplToJson(
  _$TransactionsSummaryImpl instance,
) => <String, dynamic>{
  'income': instance.income,
  'expense': instance.expense,
  'net': instance.net,
  'excluded': instance.excluded,
  'currency': instance.currency,
};

_$PaginatedTransactionsImpl _$$PaginatedTransactionsImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedTransactionsImpl(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Transaction>[],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 50,
  summary: json['summary'] == null
      ? null
      : TransactionsSummary.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PaginatedTransactionsImplToJson(
  _$PaginatedTransactionsImpl instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'summary': instance.summary?.toJson(),
};
