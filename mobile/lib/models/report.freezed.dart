// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportDataPoint _$ReportDataPointFromJson(Map<String, dynamic> json) {
  return _ReportDataPoint.fromJson(json);
}

/// @nodoc
mixin _$ReportDataPoint {
  String get date => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get value => throw _privateConstructorUsedError;

  /// Serializes this ReportDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportDataPointCopyWith<ReportDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDataPointCopyWith<$Res> {
  factory $ReportDataPointCopyWith(
    ReportDataPoint value,
    $Res Function(ReportDataPoint) then,
  ) = _$ReportDataPointCopyWithImpl<$Res, ReportDataPoint>;
  @useResult
  $Res call({String date, @JsonKey(fromJson: _toDouble) double value});
}

/// @nodoc
class _$ReportDataPointCopyWithImpl<$Res, $Val extends ReportDataPoint>
    implements $ReportDataPointCopyWith<$Res> {
  _$ReportDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportDataPointImplCopyWith<$Res>
    implements $ReportDataPointCopyWith<$Res> {
  factory _$$ReportDataPointImplCopyWith(
    _$ReportDataPointImpl value,
    $Res Function(_$ReportDataPointImpl) then,
  ) = __$$ReportDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, @JsonKey(fromJson: _toDouble) double value});
}

/// @nodoc
class __$$ReportDataPointImplCopyWithImpl<$Res>
    extends _$ReportDataPointCopyWithImpl<$Res, _$ReportDataPointImpl>
    implements _$$ReportDataPointImplCopyWith<$Res> {
  __$$ReportDataPointImplCopyWithImpl(
    _$ReportDataPointImpl _value,
    $Res Function(_$ReportDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? value = null}) {
    return _then(
      _$ReportDataPointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportDataPointImpl implements _ReportDataPoint {
  const _$ReportDataPointImpl({
    required this.date,
    @JsonKey(fromJson: _toDouble) this.value = 0,
  });

  factory _$ReportDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportDataPointImplFromJson(json);

  @override
  final String date;
  @override
  @JsonKey(fromJson: _toDouble)
  final double value;

  @override
  String toString() {
    return 'ReportDataPoint(date: $date, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, value);

  /// Create a copy of ReportDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDataPointImplCopyWith<_$ReportDataPointImpl> get copyWith =>
      __$$ReportDataPointImplCopyWithImpl<_$ReportDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportDataPointImplToJson(this);
  }
}

abstract class _ReportDataPoint implements ReportDataPoint {
  const factory _ReportDataPoint({
    required final String date,
    @JsonKey(fromJson: _toDouble) final double value,
  }) = _$ReportDataPointImpl;

  factory _ReportDataPoint.fromJson(Map<String, dynamic> json) =
      _$ReportDataPointImpl.fromJson;

  @override
  String get date;
  @override
  @JsonKey(fromJson: _toDouble)
  double get value;

  /// Create a copy of ReportDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportDataPointImplCopyWith<_$ReportDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportBreakdown _$ReportBreakdownFromJson(Map<String, dynamic> json) {
  return _ReportBreakdown.fromJson(json);
}

/// @nodoc
mixin _$ReportBreakdown {
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get value => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  /// Serializes this ReportBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportBreakdownCopyWith<ReportBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportBreakdownCopyWith<$Res> {
  factory $ReportBreakdownCopyWith(
    ReportBreakdown value,
    $Res Function(ReportBreakdown) then,
  ) = _$ReportBreakdownCopyWithImpl<$Res, ReportBreakdown>;
  @useResult
  $Res call({
    String key,
    String label,
    @JsonKey(fromJson: _toDouble) double value,
    String color,
  });
}

/// @nodoc
class _$ReportBreakdownCopyWithImpl<$Res, $Val extends ReportBreakdown>
    implements $ReportBreakdownCopyWith<$Res> {
  _$ReportBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportBreakdownImplCopyWith<$Res>
    implements $ReportBreakdownCopyWith<$Res> {
  factory _$$ReportBreakdownImplCopyWith(
    _$ReportBreakdownImpl value,
    $Res Function(_$ReportBreakdownImpl) then,
  ) = __$$ReportBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String key,
    String label,
    @JsonKey(fromJson: _toDouble) double value,
    String color,
  });
}

/// @nodoc
class __$$ReportBreakdownImplCopyWithImpl<$Res>
    extends _$ReportBreakdownCopyWithImpl<$Res, _$ReportBreakdownImpl>
    implements _$$ReportBreakdownImplCopyWith<$Res> {
  __$$ReportBreakdownImplCopyWithImpl(
    _$ReportBreakdownImpl _value,
    $Res Function(_$ReportBreakdownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(
      _$ReportBreakdownImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportBreakdownImpl implements _ReportBreakdown {
  const _$ReportBreakdownImpl({
    required this.key,
    required this.label,
    @JsonKey(fromJson: _toDouble) this.value = 0,
    this.color = '',
  });

  factory _$ReportBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportBreakdownImplFromJson(json);

  @override
  final String key;
  @override
  final String label;
  @override
  @JsonKey(fromJson: _toDouble)
  final double value;
  @override
  @JsonKey()
  final String color;

  @override
  String toString() {
    return 'ReportBreakdown(key: $key, label: $label, value: $value, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportBreakdownImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, label, value, color);

  /// Create a copy of ReportBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportBreakdownImplCopyWith<_$ReportBreakdownImpl> get copyWith =>
      __$$ReportBreakdownImplCopyWithImpl<_$ReportBreakdownImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportBreakdownImplToJson(this);
  }
}

abstract class _ReportBreakdown implements ReportBreakdown {
  const factory _ReportBreakdown({
    required final String key,
    required final String label,
    @JsonKey(fromJson: _toDouble) final double value,
    final String color,
  }) = _$ReportBreakdownImpl;

  factory _ReportBreakdown.fromJson(Map<String, dynamic> json) =
      _$ReportBreakdownImpl.fromJson;

  @override
  String get key;
  @override
  String get label;
  @override
  @JsonKey(fromJson: _toDouble)
  double get value;
  @override
  String get color;

  /// Create a copy of ReportBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportBreakdownImplCopyWith<_$ReportBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportSummary _$ReportSummaryFromJson(Map<String, dynamic> json) {
  return _ReportSummary.fromJson(json);
}

/// @nodoc
mixin _$ReportSummary {
  @JsonKey(fromJson: _toDouble)
  double get primaryValue => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toDouble)
  double get changeAmount => throw _privateConstructorUsedError;
  double? get changePercent => throw _privateConstructorUsedError;
  List<ReportBreakdown> get breakdowns => throw _privateConstructorUsedError;

  /// Serializes this ReportSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportSummaryCopyWith<ReportSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportSummaryCopyWith<$Res> {
  factory $ReportSummaryCopyWith(
    ReportSummary value,
    $Res Function(ReportSummary) then,
  ) = _$ReportSummaryCopyWithImpl<$Res, ReportSummary>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _toDouble) double primaryValue,
    @JsonKey(fromJson: _toDouble) double changeAmount,
    double? changePercent,
    List<ReportBreakdown> breakdowns,
  });
}

/// @nodoc
class _$ReportSummaryCopyWithImpl<$Res, $Val extends ReportSummary>
    implements $ReportSummaryCopyWith<$Res> {
  _$ReportSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryValue = null,
    Object? changeAmount = null,
    Object? changePercent = freezed,
    Object? breakdowns = null,
  }) {
    return _then(
      _value.copyWith(
            primaryValue: null == primaryValue
                ? _value.primaryValue
                : primaryValue // ignore: cast_nullable_to_non_nullable
                      as double,
            changeAmount: null == changeAmount
                ? _value.changeAmount
                : changeAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            changePercent: freezed == changePercent
                ? _value.changePercent
                : changePercent // ignore: cast_nullable_to_non_nullable
                      as double?,
            breakdowns: null == breakdowns
                ? _value.breakdowns
                : breakdowns // ignore: cast_nullable_to_non_nullable
                      as List<ReportBreakdown>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportSummaryImplCopyWith<$Res>
    implements $ReportSummaryCopyWith<$Res> {
  factory _$$ReportSummaryImplCopyWith(
    _$ReportSummaryImpl value,
    $Res Function(_$ReportSummaryImpl) then,
  ) = __$$ReportSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _toDouble) double primaryValue,
    @JsonKey(fromJson: _toDouble) double changeAmount,
    double? changePercent,
    List<ReportBreakdown> breakdowns,
  });
}

/// @nodoc
class __$$ReportSummaryImplCopyWithImpl<$Res>
    extends _$ReportSummaryCopyWithImpl<$Res, _$ReportSummaryImpl>
    implements _$$ReportSummaryImplCopyWith<$Res> {
  __$$ReportSummaryImplCopyWithImpl(
    _$ReportSummaryImpl _value,
    $Res Function(_$ReportSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryValue = null,
    Object? changeAmount = null,
    Object? changePercent = freezed,
    Object? breakdowns = null,
  }) {
    return _then(
      _$ReportSummaryImpl(
        primaryValue: null == primaryValue
            ? _value.primaryValue
            : primaryValue // ignore: cast_nullable_to_non_nullable
                  as double,
        changeAmount: null == changeAmount
            ? _value.changeAmount
            : changeAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        changePercent: freezed == changePercent
            ? _value.changePercent
            : changePercent // ignore: cast_nullable_to_non_nullable
                  as double?,
        breakdowns: null == breakdowns
            ? _value._breakdowns
            : breakdowns // ignore: cast_nullable_to_non_nullable
                  as List<ReportBreakdown>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportSummaryImpl implements _ReportSummary {
  const _$ReportSummaryImpl({
    @JsonKey(fromJson: _toDouble) this.primaryValue = 0,
    @JsonKey(fromJson: _toDouble) this.changeAmount = 0,
    this.changePercent,
    final List<ReportBreakdown> breakdowns = const <ReportBreakdown>[],
  }) : _breakdowns = breakdowns;

  factory _$ReportSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportSummaryImplFromJson(json);

  @override
  @JsonKey(fromJson: _toDouble)
  final double primaryValue;
  @override
  @JsonKey(fromJson: _toDouble)
  final double changeAmount;
  @override
  final double? changePercent;
  final List<ReportBreakdown> _breakdowns;
  @override
  @JsonKey()
  List<ReportBreakdown> get breakdowns {
    if (_breakdowns is EqualUnmodifiableListView) return _breakdowns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakdowns);
  }

  @override
  String toString() {
    return 'ReportSummary(primaryValue: $primaryValue, changeAmount: $changeAmount, changePercent: $changePercent, breakdowns: $breakdowns)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportSummaryImpl &&
            (identical(other.primaryValue, primaryValue) ||
                other.primaryValue == primaryValue) &&
            (identical(other.changeAmount, changeAmount) ||
                other.changeAmount == changeAmount) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            const DeepCollectionEquality().equals(
              other._breakdowns,
              _breakdowns,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    primaryValue,
    changeAmount,
    changePercent,
    const DeepCollectionEquality().hash(_breakdowns),
  );

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportSummaryImplCopyWith<_$ReportSummaryImpl> get copyWith =>
      __$$ReportSummaryImplCopyWithImpl<_$ReportSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportSummaryImplToJson(this);
  }
}

abstract class _ReportSummary implements ReportSummary {
  const factory _ReportSummary({
    @JsonKey(fromJson: _toDouble) final double primaryValue,
    @JsonKey(fromJson: _toDouble) final double changeAmount,
    final double? changePercent,
    final List<ReportBreakdown> breakdowns,
  }) = _$ReportSummaryImpl;

  factory _ReportSummary.fromJson(Map<String, dynamic> json) =
      _$ReportSummaryImpl.fromJson;

  @override
  @JsonKey(fromJson: _toDouble)
  double get primaryValue;
  @override
  @JsonKey(fromJson: _toDouble)
  double get changeAmount;
  @override
  double? get changePercent;
  @override
  List<ReportBreakdown> get breakdowns;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportSummaryImplCopyWith<_$ReportSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportMeta _$ReportMetaFromJson(Map<String, dynamic> json) {
  return _ReportMeta.fromJson(json);
}

/// @nodoc
mixin _$ReportMeta {
  String get type => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get interval => throw _privateConstructorUsedError;

  /// Serializes this ReportMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportMetaCopyWith<ReportMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportMetaCopyWith<$Res> {
  factory $ReportMetaCopyWith(
    ReportMeta value,
    $Res Function(ReportMeta) then,
  ) = _$ReportMetaCopyWithImpl<$Res, ReportMeta>;
  @useResult
  $Res call({String type, String currency, String interval});
}

/// @nodoc
class _$ReportMetaCopyWithImpl<$Res, $Val extends ReportMeta>
    implements $ReportMetaCopyWith<$Res> {
  _$ReportMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? currency = null,
    Object? interval = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            interval: null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportMetaImplCopyWith<$Res>
    implements $ReportMetaCopyWith<$Res> {
  factory _$$ReportMetaImplCopyWith(
    _$ReportMetaImpl value,
    $Res Function(_$ReportMetaImpl) then,
  ) = __$$ReportMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String currency, String interval});
}

/// @nodoc
class __$$ReportMetaImplCopyWithImpl<$Res>
    extends _$ReportMetaCopyWithImpl<$Res, _$ReportMetaImpl>
    implements _$$ReportMetaImplCopyWith<$Res> {
  __$$ReportMetaImplCopyWithImpl(
    _$ReportMetaImpl _value,
    $Res Function(_$ReportMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? currency = null,
    Object? interval = null,
  }) {
    return _then(
      _$ReportMetaImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        interval: null == interval
            ? _value.interval
            : interval // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportMetaImpl implements _ReportMeta {
  const _$ReportMetaImpl({
    required this.type,
    this.currency = 'USD',
    this.interval = 'monthly',
  });

  factory _$ReportMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportMetaImplFromJson(json);

  @override
  final String type;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final String interval;

  @override
  String toString() {
    return 'ReportMeta(type: $type, currency: $currency, interval: $interval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportMetaImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.interval, interval) ||
                other.interval == interval));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, currency, interval);

  /// Create a copy of ReportMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportMetaImplCopyWith<_$ReportMetaImpl> get copyWith =>
      __$$ReportMetaImplCopyWithImpl<_$ReportMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportMetaImplToJson(this);
  }
}

abstract class _ReportMeta implements ReportMeta {
  const factory _ReportMeta({
    required final String type,
    final String currency,
    final String interval,
  }) = _$ReportMetaImpl;

  factory _ReportMeta.fromJson(Map<String, dynamic> json) =
      _$ReportMetaImpl.fromJson;

  @override
  String get type;
  @override
  String get currency;
  @override
  String get interval;

  /// Create a copy of ReportMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportMetaImplCopyWith<_$ReportMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Report _$ReportFromJson(Map<String, dynamic> json) {
  return _Report.fromJson(json);
}

/// @nodoc
mixin _$Report {
  ReportSummary get summary => throw _privateConstructorUsedError;
  List<ReportDataPoint> get trend => throw _privateConstructorUsedError;
  ReportMeta get meta => throw _privateConstructorUsedError;

  /// Serializes this Report to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportCopyWith<Report> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCopyWith<$Res> {
  factory $ReportCopyWith(Report value, $Res Function(Report) then) =
      _$ReportCopyWithImpl<$Res, Report>;
  @useResult
  $Res call({
    ReportSummary summary,
    List<ReportDataPoint> trend,
    ReportMeta meta,
  });

  $ReportSummaryCopyWith<$Res> get summary;
  $ReportMetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$ReportCopyWithImpl<$Res, $Val extends Report>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? trend = null,
    Object? meta = null,
  }) {
    return _then(
      _value.copyWith(
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as ReportSummary,
            trend: null == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as List<ReportDataPoint>,
            meta: null == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as ReportMeta,
          )
          as $Val,
    );
  }

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportSummaryCopyWith<$Res> get summary {
    return $ReportSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportMetaCopyWith<$Res> get meta {
    return $ReportMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReportImplCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$$ReportImplCopyWith(
    _$ReportImpl value,
    $Res Function(_$ReportImpl) then,
  ) = __$$ReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ReportSummary summary,
    List<ReportDataPoint> trend,
    ReportMeta meta,
  });

  @override
  $ReportSummaryCopyWith<$Res> get summary;
  @override
  $ReportMetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$ReportImplCopyWithImpl<$Res>
    extends _$ReportCopyWithImpl<$Res, _$ReportImpl>
    implements _$$ReportImplCopyWith<$Res> {
  __$$ReportImplCopyWithImpl(
    _$ReportImpl _value,
    $Res Function(_$ReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? trend = null,
    Object? meta = null,
  }) {
    return _then(
      _$ReportImpl(
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as ReportSummary,
        trend: null == trend
            ? _value._trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as List<ReportDataPoint>,
        meta: null == meta
            ? _value.meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as ReportMeta,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportImpl implements _Report {
  const _$ReportImpl({
    required this.summary,
    final List<ReportDataPoint> trend = const <ReportDataPoint>[],
    required this.meta,
  }) : _trend = trend;

  factory _$ReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportImplFromJson(json);

  @override
  final ReportSummary summary;
  final List<ReportDataPoint> _trend;
  @override
  @JsonKey()
  List<ReportDataPoint> get trend {
    if (_trend is EqualUnmodifiableListView) return _trend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trend);
  }

  @override
  final ReportMeta meta;

  @override
  String toString() {
    return 'Report(summary: $summary, trend: $trend, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._trend, _trend) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    summary,
    const DeepCollectionEquality().hash(_trend),
    meta,
  );

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      __$$ReportImplCopyWithImpl<_$ReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportImplToJson(this);
  }
}

abstract class _Report implements Report {
  const factory _Report({
    required final ReportSummary summary,
    final List<ReportDataPoint> trend,
    required final ReportMeta meta,
  }) = _$ReportImpl;

  factory _Report.fromJson(Map<String, dynamic> json) = _$ReportImpl.fromJson;

  @override
  ReportSummary get summary;
  @override
  List<ReportDataPoint> get trend;
  @override
  ReportMeta get meta;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
