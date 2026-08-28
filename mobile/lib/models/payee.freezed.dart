// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PayeeTaxId _$PayeeTaxIdFromJson(Map<String, dynamic> json) {
  return _PayeeTaxId.fromJson(json);
}

/// @nodoc
mixin _$PayeeTaxId {
  String get kind => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this PayeeTaxId to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PayeeTaxId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PayeeTaxIdCopyWith<PayeeTaxId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayeeTaxIdCopyWith<$Res> {
  factory $PayeeTaxIdCopyWith(
    PayeeTaxId value,
    $Res Function(PayeeTaxId) then,
  ) = _$PayeeTaxIdCopyWithImpl<$Res, PayeeTaxId>;
  @useResult
  $Res call({String kind, String value});
}

/// @nodoc
class _$PayeeTaxIdCopyWithImpl<$Res, $Val extends PayeeTaxId>
    implements $PayeeTaxIdCopyWith<$Res> {
  _$PayeeTaxIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PayeeTaxId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? kind = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PayeeTaxIdImplCopyWith<$Res>
    implements $PayeeTaxIdCopyWith<$Res> {
  factory _$$PayeeTaxIdImplCopyWith(
    _$PayeeTaxIdImpl value,
    $Res Function(_$PayeeTaxIdImpl) then,
  ) = __$$PayeeTaxIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String kind, String value});
}

/// @nodoc
class __$$PayeeTaxIdImplCopyWithImpl<$Res>
    extends _$PayeeTaxIdCopyWithImpl<$Res, _$PayeeTaxIdImpl>
    implements _$$PayeeTaxIdImplCopyWith<$Res> {
  __$$PayeeTaxIdImplCopyWithImpl(
    _$PayeeTaxIdImpl _value,
    $Res Function(_$PayeeTaxIdImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PayeeTaxId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? kind = null, Object? value = null}) {
    return _then(
      _$PayeeTaxIdImpl(
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PayeeTaxIdImpl implements _PayeeTaxId {
  const _$PayeeTaxIdImpl({required this.kind, required this.value});

  factory _$PayeeTaxIdImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayeeTaxIdImplFromJson(json);

  @override
  final String kind;
  @override
  final String value;

  @override
  String toString() {
    return 'PayeeTaxId(kind: $kind, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayeeTaxIdImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, value);

  /// Create a copy of PayeeTaxId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PayeeTaxIdImplCopyWith<_$PayeeTaxIdImpl> get copyWith =>
      __$$PayeeTaxIdImplCopyWithImpl<_$PayeeTaxIdImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayeeTaxIdImplToJson(this);
  }
}

abstract class _PayeeTaxId implements PayeeTaxId {
  const factory _PayeeTaxId({
    required final String kind,
    required final String value,
  }) = _$PayeeTaxIdImpl;

  factory _PayeeTaxId.fromJson(Map<String, dynamic> json) =
      _$PayeeTaxIdImpl.fromJson;

  @override
  String get kind;
  @override
  String get value;

  /// Create a copy of PayeeTaxId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PayeeTaxIdImplCopyWith<_$PayeeTaxIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Payee _$PayeeFromJson(Map<String, dynamic> json) {
  return _Payee.fromJson(json);
}

/// @nodoc
mixin _$Payee {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Legal nature, or null when unknown — the normal state for a row sync
  /// created.
  String? get type => throw _privateConstructorUsedError;

  /// Where the row came from. Server-set at creation and never editable.
  String get source => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  List<PayeeTaxId> get taxIds => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;

  /// Serializes this Payee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PayeeCopyWith<Payee> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayeeCopyWith<$Res> {
  factory $PayeeCopyWith(Payee value, $Res Function(Payee) then) =
      _$PayeeCopyWithImpl<$Res, Payee>;
  @useResult
  $Res call({
    String id,
    String name,
    String? type,
    String source,
    bool isFavorite,
    String? notes,
    String? email,
    String? phone,
    String? address,
    String? website,
    List<PayeeTaxId> taxIds,
    String? createdAt,
    int transactionCount,
  });
}

/// @nodoc
class _$PayeeCopyWithImpl<$Res, $Val extends Payee>
    implements $PayeeCopyWith<$Res> {
  _$PayeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? source = null,
    Object? isFavorite = null,
    Object? notes = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? website = freezed,
    Object? taxIds = null,
    Object? createdAt = freezed,
    Object? transactionCount = null,
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
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            website: freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxIds: null == taxIds
                ? _value.taxIds
                : taxIds // ignore: cast_nullable_to_non_nullable
                      as List<PayeeTaxId>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            transactionCount: null == transactionCount
                ? _value.transactionCount
                : transactionCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PayeeImplCopyWith<$Res> implements $PayeeCopyWith<$Res> {
  factory _$$PayeeImplCopyWith(
    _$PayeeImpl value,
    $Res Function(_$PayeeImpl) then,
  ) = __$$PayeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? type,
    String source,
    bool isFavorite,
    String? notes,
    String? email,
    String? phone,
    String? address,
    String? website,
    List<PayeeTaxId> taxIds,
    String? createdAt,
    int transactionCount,
  });
}

/// @nodoc
class __$$PayeeImplCopyWithImpl<$Res>
    extends _$PayeeCopyWithImpl<$Res, _$PayeeImpl>
    implements _$$PayeeImplCopyWith<$Res> {
  __$$PayeeImplCopyWithImpl(
    _$PayeeImpl _value,
    $Res Function(_$PayeeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Payee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? source = null,
    Object? isFavorite = null,
    Object? notes = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? website = freezed,
    Object? taxIds = null,
    Object? createdAt = freezed,
    Object? transactionCount = null,
  }) {
    return _then(
      _$PayeeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        website: freezed == website
            ? _value.website
            : website // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxIds: null == taxIds
            ? _value._taxIds
            : taxIds // ignore: cast_nullable_to_non_nullable
                  as List<PayeeTaxId>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        transactionCount: null == transactionCount
            ? _value.transactionCount
            : transactionCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PayeeImpl implements _Payee {
  const _$PayeeImpl({
    required this.id,
    required this.name,
    this.type,
    this.source = 'manual',
    this.isFavorite = false,
    this.notes,
    this.email,
    this.phone,
    this.address,
    this.website,
    final List<PayeeTaxId> taxIds = const <PayeeTaxId>[],
    this.createdAt,
    this.transactionCount = 0,
  }) : _taxIds = taxIds;

  factory _$PayeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayeeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  /// Legal nature, or null when unknown — the normal state for a row sync
  /// created.
  @override
  final String? type;

  /// Where the row came from. Server-set at creation and never editable.
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final String? notes;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final String? website;
  final List<PayeeTaxId> _taxIds;
  @override
  @JsonKey()
  List<PayeeTaxId> get taxIds {
    if (_taxIds is EqualUnmodifiableListView) return _taxIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taxIds);
  }

  @override
  final String? createdAt;
  @override
  @JsonKey()
  final int transactionCount;

  @override
  String toString() {
    return 'Payee(id: $id, name: $name, type: $type, source: $source, isFavorite: $isFavorite, notes: $notes, email: $email, phone: $phone, address: $address, website: $website, taxIds: $taxIds, createdAt: $createdAt, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayeeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.website, website) || other.website == website) &&
            const DeepCollectionEquality().equals(other._taxIds, _taxIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    source,
    isFavorite,
    notes,
    email,
    phone,
    address,
    website,
    const DeepCollectionEquality().hash(_taxIds),
    createdAt,
    transactionCount,
  );

  /// Create a copy of Payee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PayeeImplCopyWith<_$PayeeImpl> get copyWith =>
      __$$PayeeImplCopyWithImpl<_$PayeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayeeImplToJson(this);
  }
}

abstract class _Payee implements Payee {
  const factory _Payee({
    required final String id,
    required final String name,
    final String? type,
    final String source,
    final bool isFavorite,
    final String? notes,
    final String? email,
    final String? phone,
    final String? address,
    final String? website,
    final List<PayeeTaxId> taxIds,
    final String? createdAt,
    final int transactionCount,
  }) = _$PayeeImpl;

  factory _Payee.fromJson(Map<String, dynamic> json) = _$PayeeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Legal nature, or null when unknown — the normal state for a row sync
  /// created.
  @override
  String? get type;

  /// Where the row came from. Server-set at creation and never editable.
  @override
  String get source;
  @override
  bool get isFavorite;
  @override
  String? get notes;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  String? get website;
  @override
  List<PayeeTaxId> get taxIds;
  @override
  String? get createdAt;
  @override
  int get transactionCount;

  /// Create a copy of Payee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PayeeImplCopyWith<_$PayeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PayeeSummary _$PayeeSummaryFromJson(Map<String, dynamic> json) {
  return _PayeeSummary.fromJson(json);
}

/// @nodoc
mixin _$PayeeSummary {
  Payee get payee => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDouble)
  double get totalSpent => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toDouble)
  double get totalReceived => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  Category? get mostCommonCategory => throw _privateConstructorUsedError;
  String? get lastTransactionDate => throw _privateConstructorUsedError;

  /// Serializes this PayeeSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PayeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PayeeSummaryCopyWith<PayeeSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayeeSummaryCopyWith<$Res> {
  factory $PayeeSummaryCopyWith(
    PayeeSummary value,
    $Res Function(PayeeSummary) then,
  ) = _$PayeeSummaryCopyWithImpl<$Res, PayeeSummary>;
  @useResult
  $Res call({
    Payee payee,
    @JsonKey(fromJson: toDouble) double totalSpent,
    @JsonKey(fromJson: toDouble) double totalReceived,
    int transactionCount,
    Category? mostCommonCategory,
    String? lastTransactionDate,
  });

  $PayeeCopyWith<$Res> get payee;
  $CategoryCopyWith<$Res>? get mostCommonCategory;
}

/// @nodoc
class _$PayeeSummaryCopyWithImpl<$Res, $Val extends PayeeSummary>
    implements $PayeeSummaryCopyWith<$Res> {
  _$PayeeSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PayeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payee = null,
    Object? totalSpent = null,
    Object? totalReceived = null,
    Object? transactionCount = null,
    Object? mostCommonCategory = freezed,
    Object? lastTransactionDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            payee: null == payee
                ? _value.payee
                : payee // ignore: cast_nullable_to_non_nullable
                      as Payee,
            totalSpent: null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReceived: null == totalReceived
                ? _value.totalReceived
                : totalReceived // ignore: cast_nullable_to_non_nullable
                      as double,
            transactionCount: null == transactionCount
                ? _value.transactionCount
                : transactionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            mostCommonCategory: freezed == mostCommonCategory
                ? _value.mostCommonCategory
                : mostCommonCategory // ignore: cast_nullable_to_non_nullable
                      as Category?,
            lastTransactionDate: freezed == lastTransactionDate
                ? _value.lastTransactionDate
                : lastTransactionDate // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of PayeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PayeeCopyWith<$Res> get payee {
    return $PayeeCopyWith<$Res>(_value.payee, (value) {
      return _then(_value.copyWith(payee: value) as $Val);
    });
  }

  /// Create a copy of PayeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get mostCommonCategory {
    if (_value.mostCommonCategory == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.mostCommonCategory!, (value) {
      return _then(_value.copyWith(mostCommonCategory: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PayeeSummaryImplCopyWith<$Res>
    implements $PayeeSummaryCopyWith<$Res> {
  factory _$$PayeeSummaryImplCopyWith(
    _$PayeeSummaryImpl value,
    $Res Function(_$PayeeSummaryImpl) then,
  ) = __$$PayeeSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Payee payee,
    @JsonKey(fromJson: toDouble) double totalSpent,
    @JsonKey(fromJson: toDouble) double totalReceived,
    int transactionCount,
    Category? mostCommonCategory,
    String? lastTransactionDate,
  });

  @override
  $PayeeCopyWith<$Res> get payee;
  @override
  $CategoryCopyWith<$Res>? get mostCommonCategory;
}

/// @nodoc
class __$$PayeeSummaryImplCopyWithImpl<$Res>
    extends _$PayeeSummaryCopyWithImpl<$Res, _$PayeeSummaryImpl>
    implements _$$PayeeSummaryImplCopyWith<$Res> {
  __$$PayeeSummaryImplCopyWithImpl(
    _$PayeeSummaryImpl _value,
    $Res Function(_$PayeeSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PayeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payee = null,
    Object? totalSpent = null,
    Object? totalReceived = null,
    Object? transactionCount = null,
    Object? mostCommonCategory = freezed,
    Object? lastTransactionDate = freezed,
  }) {
    return _then(
      _$PayeeSummaryImpl(
        payee: null == payee
            ? _value.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as Payee,
        totalSpent: null == totalSpent
            ? _value.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReceived: null == totalReceived
            ? _value.totalReceived
            : totalReceived // ignore: cast_nullable_to_non_nullable
                  as double,
        transactionCount: null == transactionCount
            ? _value.transactionCount
            : transactionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        mostCommonCategory: freezed == mostCommonCategory
            ? _value.mostCommonCategory
            : mostCommonCategory // ignore: cast_nullable_to_non_nullable
                  as Category?,
        lastTransactionDate: freezed == lastTransactionDate
            ? _value.lastTransactionDate
            : lastTransactionDate // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PayeeSummaryImpl implements _PayeeSummary {
  const _$PayeeSummaryImpl({
    required this.payee,
    @JsonKey(fromJson: toDouble) this.totalSpent = 0,
    @JsonKey(fromJson: toDouble) this.totalReceived = 0,
    this.transactionCount = 0,
    this.mostCommonCategory,
    this.lastTransactionDate,
  });

  factory _$PayeeSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayeeSummaryImplFromJson(json);

  @override
  final Payee payee;
  @override
  @JsonKey(fromJson: toDouble)
  final double totalSpent;
  @override
  @JsonKey(fromJson: toDouble)
  final double totalReceived;
  @override
  @JsonKey()
  final int transactionCount;
  @override
  final Category? mostCommonCategory;
  @override
  final String? lastTransactionDate;

  @override
  String toString() {
    return 'PayeeSummary(payee: $payee, totalSpent: $totalSpent, totalReceived: $totalReceived, transactionCount: $transactionCount, mostCommonCategory: $mostCommonCategory, lastTransactionDate: $lastTransactionDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayeeSummaryImpl &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.totalReceived, totalReceived) ||
                other.totalReceived == totalReceived) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.mostCommonCategory, mostCommonCategory) ||
                other.mostCommonCategory == mostCommonCategory) &&
            (identical(other.lastTransactionDate, lastTransactionDate) ||
                other.lastTransactionDate == lastTransactionDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    payee,
    totalSpent,
    totalReceived,
    transactionCount,
    mostCommonCategory,
    lastTransactionDate,
  );

  /// Create a copy of PayeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PayeeSummaryImplCopyWith<_$PayeeSummaryImpl> get copyWith =>
      __$$PayeeSummaryImplCopyWithImpl<_$PayeeSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayeeSummaryImplToJson(this);
  }
}

abstract class _PayeeSummary implements PayeeSummary {
  const factory _PayeeSummary({
    required final Payee payee,
    @JsonKey(fromJson: toDouble) final double totalSpent,
    @JsonKey(fromJson: toDouble) final double totalReceived,
    final int transactionCount,
    final Category? mostCommonCategory,
    final String? lastTransactionDate,
  }) = _$PayeeSummaryImpl;

  factory _PayeeSummary.fromJson(Map<String, dynamic> json) =
      _$PayeeSummaryImpl.fromJson;

  @override
  Payee get payee;
  @override
  @JsonKey(fromJson: toDouble)
  double get totalSpent;
  @override
  @JsonKey(fromJson: toDouble)
  double get totalReceived;
  @override
  int get transactionCount;
  @override
  Category? get mostCommonCategory;
  @override
  String? get lastTransactionDate;

  /// Create a copy of PayeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PayeeSummaryImplCopyWith<_$PayeeSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
