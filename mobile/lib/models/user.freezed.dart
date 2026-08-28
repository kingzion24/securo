// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  String? get language => throw _privateConstructorUsedError;
  String? get dateFormat => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  String? get currencyDisplay => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  bool? get onboardingCompleted => throw _privateConstructorUsedError;

  /// Minutes of inactivity before the lock screen appears. 0 disables it.
  /// The web app defaults this to 5 when unset; [idleLockMinutesOrDefault]
  /// keeps that behaviour in one place.
  int? get idleLockMinutes => throw _privateConstructorUsedError;

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
    UserPreferences value,
    $Res Function(UserPreferences) then,
  ) = _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call({
    String? language,
    String? dateFormat,
    String? timezone,
    String? currencyDisplay,
    String? displayName,
    bool? onboardingCompleted,
    int? idleLockMinutes,
  });
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = freezed,
    Object? dateFormat = freezed,
    Object? timezone = freezed,
    Object? currencyDisplay = freezed,
    Object? displayName = freezed,
    Object? onboardingCompleted = freezed,
    Object? idleLockMinutes = freezed,
  }) {
    return _then(
      _value.copyWith(
            language: freezed == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateFormat: freezed == dateFormat
                ? _value.dateFormat
                : dateFormat // ignore: cast_nullable_to_non_nullable
                      as String?,
            timezone: freezed == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String?,
            currencyDisplay: freezed == currencyDisplay
                ? _value.currencyDisplay
                : currencyDisplay // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            onboardingCompleted: freezed == onboardingCompleted
                ? _value.onboardingCompleted
                : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                      as bool?,
            idleLockMinutes: freezed == idleLockMinutes
                ? _value.idleLockMinutes
                : idleLockMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(
    _$UserPreferencesImpl value,
    $Res Function(_$UserPreferencesImpl) then,
  ) = __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? language,
    String? dateFormat,
    String? timezone,
    String? currencyDisplay,
    String? displayName,
    bool? onboardingCompleted,
    int? idleLockMinutes,
  });
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
    _$UserPreferencesImpl _value,
    $Res Function(_$UserPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = freezed,
    Object? dateFormat = freezed,
    Object? timezone = freezed,
    Object? currencyDisplay = freezed,
    Object? displayName = freezed,
    Object? onboardingCompleted = freezed,
    Object? idleLockMinutes = freezed,
  }) {
    return _then(
      _$UserPreferencesImpl(
        language: freezed == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateFormat: freezed == dateFormat
            ? _value.dateFormat
            : dateFormat // ignore: cast_nullable_to_non_nullable
                  as String?,
        timezone: freezed == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String?,
        currencyDisplay: freezed == currencyDisplay
            ? _value.currencyDisplay
            : currencyDisplay // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        onboardingCompleted: freezed == onboardingCompleted
            ? _value.onboardingCompleted
            : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        idleLockMinutes: freezed == idleLockMinutes
            ? _value.idleLockMinutes
            : idleLockMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl extends _UserPreferences {
  const _$UserPreferencesImpl({
    this.language,
    this.dateFormat,
    this.timezone,
    this.currencyDisplay,
    this.displayName,
    this.onboardingCompleted,
    this.idleLockMinutes,
  }) : super._();

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  final String? language;
  @override
  final String? dateFormat;
  @override
  final String? timezone;
  @override
  final String? currencyDisplay;
  @override
  final String? displayName;
  @override
  final bool? onboardingCompleted;

  /// Minutes of inactivity before the lock screen appears. 0 disables it.
  /// The web app defaults this to 5 when unset; [idleLockMinutesOrDefault]
  /// keeps that behaviour in one place.
  @override
  final int? idleLockMinutes;

  @override
  String toString() {
    return 'UserPreferences(language: $language, dateFormat: $dateFormat, timezone: $timezone, currencyDisplay: $currencyDisplay, displayName: $displayName, onboardingCompleted: $onboardingCompleted, idleLockMinutes: $idleLockMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.dateFormat, dateFormat) ||
                other.dateFormat == dateFormat) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.currencyDisplay, currencyDisplay) ||
                other.currencyDisplay == currencyDisplay) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            (identical(other.idleLockMinutes, idleLockMinutes) ||
                other.idleLockMinutes == idleLockMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    language,
    dateFormat,
    timezone,
    currencyDisplay,
    displayName,
    onboardingCompleted,
    idleLockMinutes,
  );

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(this);
  }
}

abstract class _UserPreferences extends UserPreferences {
  const factory _UserPreferences({
    final String? language,
    final String? dateFormat,
    final String? timezone,
    final String? currencyDisplay,
    final String? displayName,
    final bool? onboardingCompleted,
    final int? idleLockMinutes,
  }) = _$UserPreferencesImpl;
  const _UserPreferences._() : super._();

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  String? get language;
  @override
  String? get dateFormat;
  @override
  String? get timezone;
  @override
  String? get currencyDisplay;
  @override
  String? get displayName;
  @override
  bool? get onboardingCompleted;

  /// Minutes of inactivity before the lock screen appears. 0 disables it.
  /// The web app defaults this to 5 when unset; [idleLockMinutesOrDefault]
  /// keeps that behaviour in one place.
  @override
  int? get idleLockMinutes;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isSuperuser => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_2fa_enabled')
  bool get is2faEnabled => throw _privateConstructorUsedError;
  UserPreferences get preferences => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String email,
    bool isActive,
    bool isSuperuser,
    bool isVerified,
    @JsonKey(name: 'is_2fa_enabled') bool is2faEnabled,
    UserPreferences preferences,
  });

  $UserPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? isActive = null,
    Object? isSuperuser = null,
    Object? isVerified = null,
    Object? is2faEnabled = null,
    Object? preferences = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuperuser: null == isSuperuser
                ? _value.isSuperuser
                : isSuperuser // ignore: cast_nullable_to_non_nullable
                      as bool,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            is2faEnabled: null == is2faEnabled
                ? _value.is2faEnabled
                : is2faEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            preferences: null == preferences
                ? _value.preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                      as UserPreferences,
          )
          as $Val,
    );
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesCopyWith<$Res> get preferences {
    return $UserPreferencesCopyWith<$Res>(_value.preferences, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    bool isActive,
    bool isSuperuser,
    bool isVerified,
    @JsonKey(name: 'is_2fa_enabled') bool is2faEnabled,
    UserPreferences preferences,
  });

  @override
  $UserPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? isActive = null,
    Object? isSuperuser = null,
    Object? isVerified = null,
    Object? is2faEnabled = null,
    Object? preferences = null,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuperuser: null == isSuperuser
            ? _value.isSuperuser
            : isSuperuser // ignore: cast_nullable_to_non_nullable
                  as bool,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        is2faEnabled: null == is2faEnabled
            ? _value.is2faEnabled
            : is2faEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        preferences: null == preferences
            ? _value.preferences
            : preferences // ignore: cast_nullable_to_non_nullable
                  as UserPreferences,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl({
    required this.id,
    required this.email,
    required this.isActive,
    required this.isSuperuser,
    required this.isVerified,
    @JsonKey(name: 'is_2fa_enabled') required this.is2faEnabled,
    this.preferences = const UserPreferences(),
  }) : super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final bool isActive;
  @override
  final bool isSuperuser;
  @override
  final bool isVerified;
  @override
  @JsonKey(name: 'is_2fa_enabled')
  final bool is2faEnabled;
  @override
  @JsonKey()
  final UserPreferences preferences;

  @override
  String toString() {
    return 'User(id: $id, email: $email, isActive: $isActive, isSuperuser: $isSuperuser, isVerified: $isVerified, is2faEnabled: $is2faEnabled, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isSuperuser, isSuperuser) ||
                other.isSuperuser == isSuperuser) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.is2faEnabled, is2faEnabled) ||
                other.is2faEnabled == is2faEnabled) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    isActive,
    isSuperuser,
    isVerified,
    is2faEnabled,
    preferences,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User extends User {
  const factory _User({
    required final String id,
    required final String email,
    required final bool isActive,
    required final bool isSuperuser,
    required final bool isVerified,
    @JsonKey(name: 'is_2fa_enabled') required final bool is2faEnabled,
    final UserPreferences preferences,
  }) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  bool get isActive;
  @override
  bool get isSuperuser;
  @override
  bool get isVerified;
  @override
  @JsonKey(name: 'is_2fa_enabled')
  bool get is2faEnabled;
  @override
  UserPreferences get preferences;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
