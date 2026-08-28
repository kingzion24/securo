// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionSplit _$TransactionSplitFromJson(Map<String, dynamic> json) {
  return _TransactionSplit.fromJson(json);
}

/// @nodoc
mixin _$TransactionSplit {
  String get id => throw _privateConstructorUsedError;
  String get transactionId => throw _privateConstructorUsedError;
  String get groupMemberId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDouble)
  double get shareAmount => throw _privateConstructorUsedError;
  String get shareType => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDoubleOrNull)
  double? get sharePct => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TransactionSplit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionSplitCopyWith<TransactionSplit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionSplitCopyWith<$Res> {
  factory $TransactionSplitCopyWith(
    TransactionSplit value,
    $Res Function(TransactionSplit) then,
  ) = _$TransactionSplitCopyWithImpl<$Res, TransactionSplit>;
  @useResult
  $Res call({
    String id,
    String transactionId,
    String groupMemberId,
    @JsonKey(fromJson: toDouble) double shareAmount,
    String shareType,
    @JsonKey(fromJson: toDoubleOrNull) double? sharePct,
    String? notes,
    String? createdAt,
  });
}

/// @nodoc
class _$TransactionSplitCopyWithImpl<$Res, $Val extends TransactionSplit>
    implements $TransactionSplitCopyWith<$Res> {
  _$TransactionSplitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? groupMemberId = null,
    Object? shareAmount = null,
    Object? shareType = null,
    Object? sharePct = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionId: null == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String,
            groupMemberId: null == groupMemberId
                ? _value.groupMemberId
                : groupMemberId // ignore: cast_nullable_to_non_nullable
                      as String,
            shareAmount: null == shareAmount
                ? _value.shareAmount
                : shareAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            shareType: null == shareType
                ? _value.shareType
                : shareType // ignore: cast_nullable_to_non_nullable
                      as String,
            sharePct: freezed == sharePct
                ? _value.sharePct
                : sharePct // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionSplitImplCopyWith<$Res>
    implements $TransactionSplitCopyWith<$Res> {
  factory _$$TransactionSplitImplCopyWith(
    _$TransactionSplitImpl value,
    $Res Function(_$TransactionSplitImpl) then,
  ) = __$$TransactionSplitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String transactionId,
    String groupMemberId,
    @JsonKey(fromJson: toDouble) double shareAmount,
    String shareType,
    @JsonKey(fromJson: toDoubleOrNull) double? sharePct,
    String? notes,
    String? createdAt,
  });
}

/// @nodoc
class __$$TransactionSplitImplCopyWithImpl<$Res>
    extends _$TransactionSplitCopyWithImpl<$Res, _$TransactionSplitImpl>
    implements _$$TransactionSplitImplCopyWith<$Res> {
  __$$TransactionSplitImplCopyWithImpl(
    _$TransactionSplitImpl _value,
    $Res Function(_$TransactionSplitImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? groupMemberId = null,
    Object? shareAmount = null,
    Object? shareType = null,
    Object? sharePct = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$TransactionSplitImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: null == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String,
        groupMemberId: null == groupMemberId
            ? _value.groupMemberId
            : groupMemberId // ignore: cast_nullable_to_non_nullable
                  as String,
        shareAmount: null == shareAmount
            ? _value.shareAmount
            : shareAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        shareType: null == shareType
            ? _value.shareType
            : shareType // ignore: cast_nullable_to_non_nullable
                  as String,
        sharePct: freezed == sharePct
            ? _value.sharePct
            : sharePct // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionSplitImpl implements _TransactionSplit {
  const _$TransactionSplitImpl({
    required this.id,
    required this.transactionId,
    required this.groupMemberId,
    @JsonKey(fromJson: toDouble) this.shareAmount = 0,
    this.shareType = 'equal',
    @JsonKey(fromJson: toDoubleOrNull) this.sharePct,
    this.notes,
    this.createdAt,
  });

  factory _$TransactionSplitImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionSplitImplFromJson(json);

  @override
  final String id;
  @override
  final String transactionId;
  @override
  final String groupMemberId;
  @override
  @JsonKey(fromJson: toDouble)
  final double shareAmount;
  @override
  @JsonKey()
  final String shareType;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  final double? sharePct;
  @override
  final String? notes;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'TransactionSplit(id: $id, transactionId: $transactionId, groupMemberId: $groupMemberId, shareAmount: $shareAmount, shareType: $shareType, sharePct: $sharePct, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionSplitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.groupMemberId, groupMemberId) ||
                other.groupMemberId == groupMemberId) &&
            (identical(other.shareAmount, shareAmount) ||
                other.shareAmount == shareAmount) &&
            (identical(other.shareType, shareType) ||
                other.shareType == shareType) &&
            (identical(other.sharePct, sharePct) ||
                other.sharePct == sharePct) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    transactionId,
    groupMemberId,
    shareAmount,
    shareType,
    sharePct,
    notes,
    createdAt,
  );

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionSplitImplCopyWith<_$TransactionSplitImpl> get copyWith =>
      __$$TransactionSplitImplCopyWithImpl<_$TransactionSplitImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionSplitImplToJson(this);
  }
}

abstract class _TransactionSplit implements TransactionSplit {
  const factory _TransactionSplit({
    required final String id,
    required final String transactionId,
    required final String groupMemberId,
    @JsonKey(fromJson: toDouble) final double shareAmount,
    final String shareType,
    @JsonKey(fromJson: toDoubleOrNull) final double? sharePct,
    final String? notes,
    final String? createdAt,
  }) = _$TransactionSplitImpl;

  factory _TransactionSplit.fromJson(Map<String, dynamic> json) =
      _$TransactionSplitImpl.fromJson;

  @override
  String get id;
  @override
  String get transactionId;
  @override
  String get groupMemberId;
  @override
  @JsonKey(fromJson: toDouble)
  double get shareAmount;
  @override
  String get shareType;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  double? get sharePct;
  @override
  String? get notes;
  @override
  String? get createdAt;

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionSplitImplCopyWith<_$TransactionSplitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  String? get accountId => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  String? get externalId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get originalDescription => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDouble)
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  String? get payee => throw _privateConstructorUsedError;
  String? get payeeId => throw _privateConstructorUsedError;
  String? get payeeName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Set on both halves of a transfer, so the pair can be shown as one move
  /// rather than two unrelated rows.
  String? get transferPairId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDoubleOrNull)
  double? get amountPrimary => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDoubleOrNull)
  double? get fxRateUsed => throw _privateConstructorUsedError;
  bool get fxFallback => throw _privateConstructorUsedError;
  int get attachmentCount => throw _privateConstructorUsedError;
  int? get installmentNumber => throw _privateConstructorUsedError;
  int? get totalInstallments => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDoubleOrNull)
  double? get installmentTotalAmount => throw _privateConstructorUsedError;
  String? get installmentPurchaseDate => throw _privateConstructorUsedError;
  String? get installmentSeriesId => throw _privateConstructorUsedError;
  String? get billId => throw _privateConstructorUsedError;

  /// Manual override for which credit-card bill cycle this belongs to.
  /// Null means auto bucketing.
  String? get effectiveBillDate => throw _privateConstructorUsedError;
  String? get recurringTransactionId => throw _privateConstructorUsedError;
  List<TransactionSplit> get splits => throw _privateConstructorUsedError;

  /// Shared-transaction view fields, set per-request when the viewer is a
  /// linked split member but not the owner. Render [viewerShare] as the
  /// amount and treat the row as read-only — editing belongs to the
  /// parent's owner.
  bool get isShared => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDoubleOrNull)
  double? get viewerShare => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get parentOwnerName => throw _privateConstructorUsedError;

  /// Excluded from reports and dashboard aggregations.
  bool get isIgnored => throw _privateConstructorUsedError;

  /// Named `isVirtual` rather than `virtual` because the latter resolves to
  /// the `meta` package's annotation of that name inside expressions.
  @JsonKey(name: 'virtual')
  bool get isVirtual => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    String id,
    String? accountId,
    String? categoryId,
    Category? category,
    String? externalId,
    String description,
    String? originalDescription,
    @JsonKey(fromJson: toDouble) double amount,
    String currency,
    String date,
    TransactionType type,
    String source,
    TransactionStatus status,
    String? payee,
    String? payeeId,
    String? payeeName,
    String? notes,
    String? transferPairId,
    @JsonKey(fromJson: toDoubleOrNull) double? amountPrimary,
    @JsonKey(fromJson: toDoubleOrNull) double? fxRateUsed,
    bool fxFallback,
    int attachmentCount,
    int? installmentNumber,
    int? totalInstallments,
    @JsonKey(fromJson: toDoubleOrNull) double? installmentTotalAmount,
    String? installmentPurchaseDate,
    String? installmentSeriesId,
    String? billId,
    String? effectiveBillDate,
    String? recurringTransactionId,
    List<TransactionSplit> splits,
    bool isShared,
    @JsonKey(fromJson: toDoubleOrNull) double? viewerShare,
    String? groupId,
    String? parentOwnerName,
    bool isIgnored,
    @JsonKey(name: 'virtual') bool isVirtual,
  });

  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = freezed,
    Object? categoryId = freezed,
    Object? category = freezed,
    Object? externalId = freezed,
    Object? description = null,
    Object? originalDescription = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? date = null,
    Object? type = null,
    Object? source = null,
    Object? status = null,
    Object? payee = freezed,
    Object? payeeId = freezed,
    Object? payeeName = freezed,
    Object? notes = freezed,
    Object? transferPairId = freezed,
    Object? amountPrimary = freezed,
    Object? fxRateUsed = freezed,
    Object? fxFallback = null,
    Object? attachmentCount = null,
    Object? installmentNumber = freezed,
    Object? totalInstallments = freezed,
    Object? installmentTotalAmount = freezed,
    Object? installmentPurchaseDate = freezed,
    Object? installmentSeriesId = freezed,
    Object? billId = freezed,
    Object? effectiveBillDate = freezed,
    Object? recurringTransactionId = freezed,
    Object? splits = null,
    Object? isShared = null,
    Object? viewerShare = freezed,
    Object? groupId = freezed,
    Object? parentOwnerName = freezed,
    Object? isIgnored = null,
    Object? isVirtual = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            accountId: freezed == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as Category?,
            externalId: freezed == externalId
                ? _value.externalId
                : externalId // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            originalDescription: freezed == originalDescription
                ? _value.originalDescription
                : originalDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransactionStatus,
            payee: freezed == payee
                ? _value.payee
                : payee // ignore: cast_nullable_to_non_nullable
                      as String?,
            payeeId: freezed == payeeId
                ? _value.payeeId
                : payeeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            payeeName: freezed == payeeName
                ? _value.payeeName
                : payeeName // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            transferPairId: freezed == transferPairId
                ? _value.transferPairId
                : transferPairId // ignore: cast_nullable_to_non_nullable
                      as String?,
            amountPrimary: freezed == amountPrimary
                ? _value.amountPrimary
                : amountPrimary // ignore: cast_nullable_to_non_nullable
                      as double?,
            fxRateUsed: freezed == fxRateUsed
                ? _value.fxRateUsed
                : fxRateUsed // ignore: cast_nullable_to_non_nullable
                      as double?,
            fxFallback: null == fxFallback
                ? _value.fxFallback
                : fxFallback // ignore: cast_nullable_to_non_nullable
                      as bool,
            attachmentCount: null == attachmentCount
                ? _value.attachmentCount
                : attachmentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            installmentNumber: freezed == installmentNumber
                ? _value.installmentNumber
                : installmentNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalInstallments: freezed == totalInstallments
                ? _value.totalInstallments
                : totalInstallments // ignore: cast_nullable_to_non_nullable
                      as int?,
            installmentTotalAmount: freezed == installmentTotalAmount
                ? _value.installmentTotalAmount
                : installmentTotalAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            installmentPurchaseDate: freezed == installmentPurchaseDate
                ? _value.installmentPurchaseDate
                : installmentPurchaseDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            installmentSeriesId: freezed == installmentSeriesId
                ? _value.installmentSeriesId
                : installmentSeriesId // ignore: cast_nullable_to_non_nullable
                      as String?,
            billId: freezed == billId
                ? _value.billId
                : billId // ignore: cast_nullable_to_non_nullable
                      as String?,
            effectiveBillDate: freezed == effectiveBillDate
                ? _value.effectiveBillDate
                : effectiveBillDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            recurringTransactionId: freezed == recurringTransactionId
                ? _value.recurringTransactionId
                : recurringTransactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            splits: null == splits
                ? _value.splits
                : splits // ignore: cast_nullable_to_non_nullable
                      as List<TransactionSplit>,
            isShared: null == isShared
                ? _value.isShared
                : isShared // ignore: cast_nullable_to_non_nullable
                      as bool,
            viewerShare: freezed == viewerShare
                ? _value.viewerShare
                : viewerShare // ignore: cast_nullable_to_non_nullable
                      as double?,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            parentOwnerName: freezed == parentOwnerName
                ? _value.parentOwnerName
                : parentOwnerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isIgnored: null == isIgnored
                ? _value.isIgnored
                : isIgnored // ignore: cast_nullable_to_non_nullable
                      as bool,
            isVirtual: null == isVirtual
                ? _value.isVirtual
                : isVirtual // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? accountId,
    String? categoryId,
    Category? category,
    String? externalId,
    String description,
    String? originalDescription,
    @JsonKey(fromJson: toDouble) double amount,
    String currency,
    String date,
    TransactionType type,
    String source,
    TransactionStatus status,
    String? payee,
    String? payeeId,
    String? payeeName,
    String? notes,
    String? transferPairId,
    @JsonKey(fromJson: toDoubleOrNull) double? amountPrimary,
    @JsonKey(fromJson: toDoubleOrNull) double? fxRateUsed,
    bool fxFallback,
    int attachmentCount,
    int? installmentNumber,
    int? totalInstallments,
    @JsonKey(fromJson: toDoubleOrNull) double? installmentTotalAmount,
    String? installmentPurchaseDate,
    String? installmentSeriesId,
    String? billId,
    String? effectiveBillDate,
    String? recurringTransactionId,
    List<TransactionSplit> splits,
    bool isShared,
    @JsonKey(fromJson: toDoubleOrNull) double? viewerShare,
    String? groupId,
    String? parentOwnerName,
    bool isIgnored,
    @JsonKey(name: 'virtual') bool isVirtual,
  });

  @override
  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = freezed,
    Object? categoryId = freezed,
    Object? category = freezed,
    Object? externalId = freezed,
    Object? description = null,
    Object? originalDescription = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? date = null,
    Object? type = null,
    Object? source = null,
    Object? status = null,
    Object? payee = freezed,
    Object? payeeId = freezed,
    Object? payeeName = freezed,
    Object? notes = freezed,
    Object? transferPairId = freezed,
    Object? amountPrimary = freezed,
    Object? fxRateUsed = freezed,
    Object? fxFallback = null,
    Object? attachmentCount = null,
    Object? installmentNumber = freezed,
    Object? totalInstallments = freezed,
    Object? installmentTotalAmount = freezed,
    Object? installmentPurchaseDate = freezed,
    Object? installmentSeriesId = freezed,
    Object? billId = freezed,
    Object? effectiveBillDate = freezed,
    Object? recurringTransactionId = freezed,
    Object? splits = null,
    Object? isShared = null,
    Object? viewerShare = freezed,
    Object? groupId = freezed,
    Object? parentOwnerName = freezed,
    Object? isIgnored = null,
    Object? isVirtual = null,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: freezed == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as Category?,
        externalId: freezed == externalId
            ? _value.externalId
            : externalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        originalDescription: freezed == originalDescription
            ? _value.originalDescription
            : originalDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransactionStatus,
        payee: freezed == payee
            ? _value.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        payeeId: freezed == payeeId
            ? _value.payeeId
            : payeeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        payeeName: freezed == payeeName
            ? _value.payeeName
            : payeeName // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        transferPairId: freezed == transferPairId
            ? _value.transferPairId
            : transferPairId // ignore: cast_nullable_to_non_nullable
                  as String?,
        amountPrimary: freezed == amountPrimary
            ? _value.amountPrimary
            : amountPrimary // ignore: cast_nullable_to_non_nullable
                  as double?,
        fxRateUsed: freezed == fxRateUsed
            ? _value.fxRateUsed
            : fxRateUsed // ignore: cast_nullable_to_non_nullable
                  as double?,
        fxFallback: null == fxFallback
            ? _value.fxFallback
            : fxFallback // ignore: cast_nullable_to_non_nullable
                  as bool,
        attachmentCount: null == attachmentCount
            ? _value.attachmentCount
            : attachmentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        installmentNumber: freezed == installmentNumber
            ? _value.installmentNumber
            : installmentNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalInstallments: freezed == totalInstallments
            ? _value.totalInstallments
            : totalInstallments // ignore: cast_nullable_to_non_nullable
                  as int?,
        installmentTotalAmount: freezed == installmentTotalAmount
            ? _value.installmentTotalAmount
            : installmentTotalAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        installmentPurchaseDate: freezed == installmentPurchaseDate
            ? _value.installmentPurchaseDate
            : installmentPurchaseDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        installmentSeriesId: freezed == installmentSeriesId
            ? _value.installmentSeriesId
            : installmentSeriesId // ignore: cast_nullable_to_non_nullable
                  as String?,
        billId: freezed == billId
            ? _value.billId
            : billId // ignore: cast_nullable_to_non_nullable
                  as String?,
        effectiveBillDate: freezed == effectiveBillDate
            ? _value.effectiveBillDate
            : effectiveBillDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        recurringTransactionId: freezed == recurringTransactionId
            ? _value.recurringTransactionId
            : recurringTransactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        splits: null == splits
            ? _value._splits
            : splits // ignore: cast_nullable_to_non_nullable
                  as List<TransactionSplit>,
        isShared: null == isShared
            ? _value.isShared
            : isShared // ignore: cast_nullable_to_non_nullable
                  as bool,
        viewerShare: freezed == viewerShare
            ? _value.viewerShare
            : viewerShare // ignore: cast_nullable_to_non_nullable
                  as double?,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentOwnerName: freezed == parentOwnerName
            ? _value.parentOwnerName
            : parentOwnerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isIgnored: null == isIgnored
            ? _value.isIgnored
            : isIgnored // ignore: cast_nullable_to_non_nullable
                  as bool,
        isVirtual: null == isVirtual
            ? _value.isVirtual
            : isVirtual // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl extends _Transaction {
  const _$TransactionImpl({
    required this.id,
    this.accountId,
    this.categoryId,
    this.category,
    this.externalId,
    this.description = '',
    this.originalDescription,
    @JsonKey(fromJson: toDouble) this.amount = 0,
    this.currency = 'USD',
    required this.date,
    this.type = TransactionType.debit,
    this.source = '',
    this.status = TransactionStatus.posted,
    this.payee,
    this.payeeId,
    this.payeeName,
    this.notes,
    this.transferPairId,
    @JsonKey(fromJson: toDoubleOrNull) this.amountPrimary,
    @JsonKey(fromJson: toDoubleOrNull) this.fxRateUsed,
    this.fxFallback = false,
    this.attachmentCount = 0,
    this.installmentNumber,
    this.totalInstallments,
    @JsonKey(fromJson: toDoubleOrNull) this.installmentTotalAmount,
    this.installmentPurchaseDate,
    this.installmentSeriesId,
    this.billId,
    this.effectiveBillDate,
    this.recurringTransactionId,
    final List<TransactionSplit> splits = const <TransactionSplit>[],
    this.isShared = false,
    @JsonKey(fromJson: toDoubleOrNull) this.viewerShare,
    this.groupId,
    this.parentOwnerName,
    this.isIgnored = false,
    @JsonKey(name: 'virtual') this.isVirtual = false,
  }) : _splits = splits,
       super._();

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String? accountId;
  @override
  final String? categoryId;
  @override
  final Category? category;
  @override
  final String? externalId;
  @override
  @JsonKey()
  final String description;
  @override
  final String? originalDescription;
  @override
  @JsonKey(fromJson: toDouble)
  final double amount;
  @override
  @JsonKey()
  final String currency;
  @override
  final String date;
  @override
  @JsonKey()
  final TransactionType type;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey()
  final TransactionStatus status;
  @override
  final String? payee;
  @override
  final String? payeeId;
  @override
  final String? payeeName;
  @override
  final String? notes;

  /// Set on both halves of a transfer, so the pair can be shown as one move
  /// rather than two unrelated rows.
  @override
  final String? transferPairId;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  final double? amountPrimary;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  final double? fxRateUsed;
  @override
  @JsonKey()
  final bool fxFallback;
  @override
  @JsonKey()
  final int attachmentCount;
  @override
  final int? installmentNumber;
  @override
  final int? totalInstallments;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  final double? installmentTotalAmount;
  @override
  final String? installmentPurchaseDate;
  @override
  final String? installmentSeriesId;
  @override
  final String? billId;

  /// Manual override for which credit-card bill cycle this belongs to.
  /// Null means auto bucketing.
  @override
  final String? effectiveBillDate;
  @override
  final String? recurringTransactionId;
  final List<TransactionSplit> _splits;
  @override
  @JsonKey()
  List<TransactionSplit> get splits {
    if (_splits is EqualUnmodifiableListView) return _splits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_splits);
  }

  /// Shared-transaction view fields, set per-request when the viewer is a
  /// linked split member but not the owner. Render [viewerShare] as the
  /// amount and treat the row as read-only — editing belongs to the
  /// parent's owner.
  @override
  @JsonKey()
  final bool isShared;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  final double? viewerShare;
  @override
  final String? groupId;
  @override
  final String? parentOwnerName;

  /// Excluded from reports and dashboard aggregations.
  @override
  @JsonKey()
  final bool isIgnored;

  /// Named `isVirtual` rather than `virtual` because the latter resolves to
  /// the `meta` package's annotation of that name inside expressions.
  @override
  @JsonKey(name: 'virtual')
  final bool isVirtual;

  @override
  String toString() {
    return 'Transaction(id: $id, accountId: $accountId, categoryId: $categoryId, category: $category, externalId: $externalId, description: $description, originalDescription: $originalDescription, amount: $amount, currency: $currency, date: $date, type: $type, source: $source, status: $status, payee: $payee, payeeId: $payeeId, payeeName: $payeeName, notes: $notes, transferPairId: $transferPairId, amountPrimary: $amountPrimary, fxRateUsed: $fxRateUsed, fxFallback: $fxFallback, attachmentCount: $attachmentCount, installmentNumber: $installmentNumber, totalInstallments: $totalInstallments, installmentTotalAmount: $installmentTotalAmount, installmentPurchaseDate: $installmentPurchaseDate, installmentSeriesId: $installmentSeriesId, billId: $billId, effectiveBillDate: $effectiveBillDate, recurringTransactionId: $recurringTransactionId, splits: $splits, isShared: $isShared, viewerShare: $viewerShare, groupId: $groupId, parentOwnerName: $parentOwnerName, isIgnored: $isIgnored, isVirtual: $isVirtual)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.originalDescription, originalDescription) ||
                other.originalDescription == originalDescription) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.payeeId, payeeId) || other.payeeId == payeeId) &&
            (identical(other.payeeName, payeeName) ||
                other.payeeName == payeeName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.transferPairId, transferPairId) ||
                other.transferPairId == transferPairId) &&
            (identical(other.amountPrimary, amountPrimary) ||
                other.amountPrimary == amountPrimary) &&
            (identical(other.fxRateUsed, fxRateUsed) ||
                other.fxRateUsed == fxRateUsed) &&
            (identical(other.fxFallback, fxFallback) ||
                other.fxFallback == fxFallback) &&
            (identical(other.attachmentCount, attachmentCount) ||
                other.attachmentCount == attachmentCount) &&
            (identical(other.installmentNumber, installmentNumber) ||
                other.installmentNumber == installmentNumber) &&
            (identical(other.totalInstallments, totalInstallments) ||
                other.totalInstallments == totalInstallments) &&
            (identical(other.installmentTotalAmount, installmentTotalAmount) ||
                other.installmentTotalAmount == installmentTotalAmount) &&
            (identical(
                  other.installmentPurchaseDate,
                  installmentPurchaseDate,
                ) ||
                other.installmentPurchaseDate == installmentPurchaseDate) &&
            (identical(other.installmentSeriesId, installmentSeriesId) ||
                other.installmentSeriesId == installmentSeriesId) &&
            (identical(other.billId, billId) || other.billId == billId) &&
            (identical(other.effectiveBillDate, effectiveBillDate) ||
                other.effectiveBillDate == effectiveBillDate) &&
            (identical(other.recurringTransactionId, recurringTransactionId) ||
                other.recurringTransactionId == recurringTransactionId) &&
            const DeepCollectionEquality().equals(other._splits, _splits) &&
            (identical(other.isShared, isShared) ||
                other.isShared == isShared) &&
            (identical(other.viewerShare, viewerShare) ||
                other.viewerShare == viewerShare) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.parentOwnerName, parentOwnerName) ||
                other.parentOwnerName == parentOwnerName) &&
            (identical(other.isIgnored, isIgnored) ||
                other.isIgnored == isIgnored) &&
            (identical(other.isVirtual, isVirtual) ||
                other.isVirtual == isVirtual));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    accountId,
    categoryId,
    category,
    externalId,
    description,
    originalDescription,
    amount,
    currency,
    date,
    type,
    source,
    status,
    payee,
    payeeId,
    payeeName,
    notes,
    transferPairId,
    amountPrimary,
    fxRateUsed,
    fxFallback,
    attachmentCount,
    installmentNumber,
    totalInstallments,
    installmentTotalAmount,
    installmentPurchaseDate,
    installmentSeriesId,
    billId,
    effectiveBillDate,
    recurringTransactionId,
    const DeepCollectionEquality().hash(_splits),
    isShared,
    viewerShare,
    groupId,
    parentOwnerName,
    isIgnored,
    isVirtual,
  ]);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(this);
  }
}

abstract class _Transaction extends Transaction {
  const factory _Transaction({
    required final String id,
    final String? accountId,
    final String? categoryId,
    final Category? category,
    final String? externalId,
    final String description,
    final String? originalDescription,
    @JsonKey(fromJson: toDouble) final double amount,
    final String currency,
    required final String date,
    final TransactionType type,
    final String source,
    final TransactionStatus status,
    final String? payee,
    final String? payeeId,
    final String? payeeName,
    final String? notes,
    final String? transferPairId,
    @JsonKey(fromJson: toDoubleOrNull) final double? amountPrimary,
    @JsonKey(fromJson: toDoubleOrNull) final double? fxRateUsed,
    final bool fxFallback,
    final int attachmentCount,
    final int? installmentNumber,
    final int? totalInstallments,
    @JsonKey(fromJson: toDoubleOrNull) final double? installmentTotalAmount,
    final String? installmentPurchaseDate,
    final String? installmentSeriesId,
    final String? billId,
    final String? effectiveBillDate,
    final String? recurringTransactionId,
    final List<TransactionSplit> splits,
    final bool isShared,
    @JsonKey(fromJson: toDoubleOrNull) final double? viewerShare,
    final String? groupId,
    final String? parentOwnerName,
    final bool isIgnored,
    @JsonKey(name: 'virtual') final bool isVirtual,
  }) = _$TransactionImpl;
  const _Transaction._() : super._();

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  String get id;
  @override
  String? get accountId;
  @override
  String? get categoryId;
  @override
  Category? get category;
  @override
  String? get externalId;
  @override
  String get description;
  @override
  String? get originalDescription;
  @override
  @JsonKey(fromJson: toDouble)
  double get amount;
  @override
  String get currency;
  @override
  String get date;
  @override
  TransactionType get type;
  @override
  String get source;
  @override
  TransactionStatus get status;
  @override
  String? get payee;
  @override
  String? get payeeId;
  @override
  String? get payeeName;
  @override
  String? get notes;

  /// Set on both halves of a transfer, so the pair can be shown as one move
  /// rather than two unrelated rows.
  @override
  String? get transferPairId;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  double? get amountPrimary;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  double? get fxRateUsed;
  @override
  bool get fxFallback;
  @override
  int get attachmentCount;
  @override
  int? get installmentNumber;
  @override
  int? get totalInstallments;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  double? get installmentTotalAmount;
  @override
  String? get installmentPurchaseDate;
  @override
  String? get installmentSeriesId;
  @override
  String? get billId;

  /// Manual override for which credit-card bill cycle this belongs to.
  /// Null means auto bucketing.
  @override
  String? get effectiveBillDate;
  @override
  String? get recurringTransactionId;
  @override
  List<TransactionSplit> get splits;

  /// Shared-transaction view fields, set per-request when the viewer is a
  /// linked split member but not the owner. Render [viewerShare] as the
  /// amount and treat the row as read-only — editing belongs to the
  /// parent's owner.
  @override
  bool get isShared;
  @override
  @JsonKey(fromJson: toDoubleOrNull)
  double? get viewerShare;
  @override
  String? get groupId;
  @override
  String? get parentOwnerName;

  /// Excluded from reports and dashboard aggregations.
  @override
  bool get isIgnored;

  /// Named `isVirtual` rather than `virtual` because the latter resolves to
  /// the `meta` package's annotation of that name inside expressions.
  @override
  @JsonKey(name: 'virtual')
  bool get isVirtual;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionsSummary _$TransactionsSummaryFromJson(Map<String, dynamic> json) {
  return _TransactionsSummary.fromJson(json);
}

/// @nodoc
mixin _$TransactionsSummary {
  @JsonKey(fromJson: toDouble)
  double get income => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDouble)
  double get expense => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDouble)
  double get net => throw _privateConstructorUsedError;

  /// Absolute total of everything excluded from income/expense for the same
  /// rows — transfers, treat-as-transfer categories and ignored items.
  @JsonKey(fromJson: toDouble)
  double get excluded => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this TransactionsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionsSummaryCopyWith<TransactionsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionsSummaryCopyWith<$Res> {
  factory $TransactionsSummaryCopyWith(
    TransactionsSummary value,
    $Res Function(TransactionsSummary) then,
  ) = _$TransactionsSummaryCopyWithImpl<$Res, TransactionsSummary>;
  @useResult
  $Res call({
    @JsonKey(fromJson: toDouble) double income,
    @JsonKey(fromJson: toDouble) double expense,
    @JsonKey(fromJson: toDouble) double net,
    @JsonKey(fromJson: toDouble) double excluded,
    String currency,
  });
}

/// @nodoc
class _$TransactionsSummaryCopyWithImpl<$Res, $Val extends TransactionsSummary>
    implements $TransactionsSummaryCopyWith<$Res> {
  _$TransactionsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? net = null,
    Object? excluded = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            income: null == income
                ? _value.income
                : income // ignore: cast_nullable_to_non_nullable
                      as double,
            expense: null == expense
                ? _value.expense
                : expense // ignore: cast_nullable_to_non_nullable
                      as double,
            net: null == net
                ? _value.net
                : net // ignore: cast_nullable_to_non_nullable
                      as double,
            excluded: null == excluded
                ? _value.excluded
                : excluded // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionsSummaryImplCopyWith<$Res>
    implements $TransactionsSummaryCopyWith<$Res> {
  factory _$$TransactionsSummaryImplCopyWith(
    _$TransactionsSummaryImpl value,
    $Res Function(_$TransactionsSummaryImpl) then,
  ) = __$$TransactionsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: toDouble) double income,
    @JsonKey(fromJson: toDouble) double expense,
    @JsonKey(fromJson: toDouble) double net,
    @JsonKey(fromJson: toDouble) double excluded,
    String currency,
  });
}

/// @nodoc
class __$$TransactionsSummaryImplCopyWithImpl<$Res>
    extends _$TransactionsSummaryCopyWithImpl<$Res, _$TransactionsSummaryImpl>
    implements _$$TransactionsSummaryImplCopyWith<$Res> {
  __$$TransactionsSummaryImplCopyWithImpl(
    _$TransactionsSummaryImpl _value,
    $Res Function(_$TransactionsSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? net = null,
    Object? excluded = null,
    Object? currency = null,
  }) {
    return _then(
      _$TransactionsSummaryImpl(
        income: null == income
            ? _value.income
            : income // ignore: cast_nullable_to_non_nullable
                  as double,
        expense: null == expense
            ? _value.expense
            : expense // ignore: cast_nullable_to_non_nullable
                  as double,
        net: null == net
            ? _value.net
            : net // ignore: cast_nullable_to_non_nullable
                  as double,
        excluded: null == excluded
            ? _value.excluded
            : excluded // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionsSummaryImpl implements _TransactionsSummary {
  const _$TransactionsSummaryImpl({
    @JsonKey(fromJson: toDouble) this.income = 0,
    @JsonKey(fromJson: toDouble) this.expense = 0,
    @JsonKey(fromJson: toDouble) this.net = 0,
    @JsonKey(fromJson: toDouble) this.excluded = 0,
    this.currency = 'USD',
  });

  factory _$TransactionsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionsSummaryImplFromJson(json);

  @override
  @JsonKey(fromJson: toDouble)
  final double income;
  @override
  @JsonKey(fromJson: toDouble)
  final double expense;
  @override
  @JsonKey(fromJson: toDouble)
  final double net;

  /// Absolute total of everything excluded from income/expense for the same
  /// rows — transfers, treat-as-transfer categories and ignored items.
  @override
  @JsonKey(fromJson: toDouble)
  final double excluded;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'TransactionsSummary(income: $income, expense: $expense, net: $net, excluded: $excluded, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionsSummaryImpl &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.net, net) || other.net == net) &&
            (identical(other.excluded, excluded) ||
                other.excluded == excluded) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, income, expense, net, excluded, currency);

  /// Create a copy of TransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionsSummaryImplCopyWith<_$TransactionsSummaryImpl> get copyWith =>
      __$$TransactionsSummaryImplCopyWithImpl<_$TransactionsSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionsSummaryImplToJson(this);
  }
}

abstract class _TransactionsSummary implements TransactionsSummary {
  const factory _TransactionsSummary({
    @JsonKey(fromJson: toDouble) final double income,
    @JsonKey(fromJson: toDouble) final double expense,
    @JsonKey(fromJson: toDouble) final double net,
    @JsonKey(fromJson: toDouble) final double excluded,
    final String currency,
  }) = _$TransactionsSummaryImpl;

  factory _TransactionsSummary.fromJson(Map<String, dynamic> json) =
      _$TransactionsSummaryImpl.fromJson;

  @override
  @JsonKey(fromJson: toDouble)
  double get income;
  @override
  @JsonKey(fromJson: toDouble)
  double get expense;
  @override
  @JsonKey(fromJson: toDouble)
  double get net;

  /// Absolute total of everything excluded from income/expense for the same
  /// rows — transfers, treat-as-transfer categories and ignored items.
  @override
  @JsonKey(fromJson: toDouble)
  double get excluded;
  @override
  String get currency;

  /// Create a copy of TransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionsSummaryImplCopyWith<_$TransactionsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginatedTransactions _$PaginatedTransactionsFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedTransactions.fromJson(json);
}

/// @nodoc
mixin _$PaginatedTransactions {
  List<Transaction> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;

  /// Named `limit` on the wire, matching `PaginatedResponse<T>` on the web.
  int get limit => throw _privateConstructorUsedError;
  TransactionsSummary? get summary => throw _privateConstructorUsedError;

  /// Serializes this PaginatedTransactions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedTransactions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedTransactionsCopyWith<PaginatedTransactions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedTransactionsCopyWith<$Res> {
  factory $PaginatedTransactionsCopyWith(
    PaginatedTransactions value,
    $Res Function(PaginatedTransactions) then,
  ) = _$PaginatedTransactionsCopyWithImpl<$Res, PaginatedTransactions>;
  @useResult
  $Res call({
    List<Transaction> items,
    int total,
    int page,
    int limit,
    TransactionsSummary? summary,
  });

  $TransactionsSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class _$PaginatedTransactionsCopyWithImpl<
  $Res,
  $Val extends PaginatedTransactions
>
    implements $PaginatedTransactionsCopyWith<$Res> {
  _$PaginatedTransactionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedTransactions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? summary = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<Transaction>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            summary: freezed == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as TransactionsSummary?,
          )
          as $Val,
    );
  }

  /// Create a copy of PaginatedTransactions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionsSummaryCopyWith<$Res>? get summary {
    if (_value.summary == null) {
      return null;
    }

    return $TransactionsSummaryCopyWith<$Res>(_value.summary!, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaginatedTransactionsImplCopyWith<$Res>
    implements $PaginatedTransactionsCopyWith<$Res> {
  factory _$$PaginatedTransactionsImplCopyWith(
    _$PaginatedTransactionsImpl value,
    $Res Function(_$PaginatedTransactionsImpl) then,
  ) = __$$PaginatedTransactionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Transaction> items,
    int total,
    int page,
    int limit,
    TransactionsSummary? summary,
  });

  @override
  $TransactionsSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class __$$PaginatedTransactionsImplCopyWithImpl<$Res>
    extends
        _$PaginatedTransactionsCopyWithImpl<$Res, _$PaginatedTransactionsImpl>
    implements _$$PaginatedTransactionsImplCopyWith<$Res> {
  __$$PaginatedTransactionsImplCopyWithImpl(
    _$PaginatedTransactionsImpl _value,
    $Res Function(_$PaginatedTransactionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedTransactions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? summary = freezed,
  }) {
    return _then(
      _$PaginatedTransactionsImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<Transaction>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        summary: freezed == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as TransactionsSummary?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedTransactionsImpl extends _PaginatedTransactions {
  const _$PaginatedTransactionsImpl({
    final List<Transaction> items = const <Transaction>[],
    this.total = 0,
    this.page = 1,
    this.limit = 50,
    this.summary,
  }) : _items = items,
       super._();

  factory _$PaginatedTransactionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedTransactionsImplFromJson(json);

  final List<Transaction> _items;
  @override
  @JsonKey()
  List<Transaction> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int page;

  /// Named `limit` on the wire, matching `PaginatedResponse<T>` on the web.
  @override
  @JsonKey()
  final int limit;
  @override
  final TransactionsSummary? summary;

  @override
  String toString() {
    return 'PaginatedTransactions(items: $items, total: $total, page: $page, limit: $limit, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedTransactionsImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    total,
    page,
    limit,
    summary,
  );

  /// Create a copy of PaginatedTransactions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedTransactionsImplCopyWith<_$PaginatedTransactionsImpl>
  get copyWith =>
      __$$PaginatedTransactionsImplCopyWithImpl<_$PaginatedTransactionsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedTransactionsImplToJson(this);
  }
}

abstract class _PaginatedTransactions extends PaginatedTransactions {
  const factory _PaginatedTransactions({
    final List<Transaction> items,
    final int total,
    final int page,
    final int limit,
    final TransactionsSummary? summary,
  }) = _$PaginatedTransactionsImpl;
  const _PaginatedTransactions._() : super._();

  factory _PaginatedTransactions.fromJson(Map<String, dynamic> json) =
      _$PaginatedTransactionsImpl.fromJson;

  @override
  List<Transaction> get items;
  @override
  int get total;
  @override
  int get page;

  /// Named `limit` on the wire, matching `PaginatedResponse<T>` on the web.
  @override
  int get limit;
  @override
  TransactionsSummary? get summary;

  /// Create a copy of PaginatedTransactions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedTransactionsImplCopyWith<_$PaginatedTransactionsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
