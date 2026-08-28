// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Workspace _$WorkspaceFromJson(Map<String, dynamic> json) {
  return _Workspace.fromJson(json);
}

/// @nodoc
mixin _$Workspace {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Widened to a plain String on purpose, matching the web types: a
  /// workspace stored before the current kind list still has to render.
  String get kind => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  String get defaultCurrency => throw _privateConstructorUsedError;
  String? get locale => throw _privateConstructorUsedError;
  String? get taxJurisdiction => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get createdByUserId => throw _privateConstructorUsedError;
  String? get managedByUserId => throw _privateConstructorUsedError;
  WorkspaceRole? get role => throw _privateConstructorUsedError;

  /// Modules this workspace shows. Resolved server-side — the app never
  /// decides this locally, or the two copies drift and the user sees a
  /// module the server thinks is off.
  List<String> get enabledModules => throw _privateConstructorUsedError;

  /// Serializes this Workspace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceCopyWith<Workspace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceCopyWith<$Res> {
  factory $WorkspaceCopyWith(Workspace value, $Res Function(Workspace) then) =
      _$WorkspaceCopyWithImpl<$Res, Workspace>;
  @useResult
  $Res call({
    String id,
    String name,
    String kind,
    bool isArchived,
    String defaultCurrency,
    String? locale,
    String? taxJurisdiction,
    String? icon,
    String? color,
    String? createdAt,
    String? createdByUserId,
    String? managedByUserId,
    WorkspaceRole? role,
    List<String> enabledModules,
  });
}

/// @nodoc
class _$WorkspaceCopyWithImpl<$Res, $Val extends Workspace>
    implements $WorkspaceCopyWith<$Res> {
  _$WorkspaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? kind = null,
    Object? isArchived = null,
    Object? defaultCurrency = null,
    Object? locale = freezed,
    Object? taxJurisdiction = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? createdAt = freezed,
    Object? createdByUserId = freezed,
    Object? managedByUserId = freezed,
    Object? role = freezed,
    Object? enabledModules = null,
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
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as String,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            defaultCurrency: null == defaultCurrency
                ? _value.defaultCurrency
                : defaultCurrency // ignore: cast_nullable_to_non_nullable
                      as String,
            locale: freezed == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxJurisdiction: freezed == taxJurisdiction
                ? _value.taxJurisdiction
                : taxJurisdiction // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdByUserId: freezed == createdByUserId
                ? _value.createdByUserId
                : createdByUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            managedByUserId: freezed == managedByUserId
                ? _value.managedByUserId
                : managedByUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as WorkspaceRole?,
            enabledModules: null == enabledModules
                ? _value.enabledModules
                : enabledModules // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkspaceImplCopyWith<$Res>
    implements $WorkspaceCopyWith<$Res> {
  factory _$$WorkspaceImplCopyWith(
    _$WorkspaceImpl value,
    $Res Function(_$WorkspaceImpl) then,
  ) = __$$WorkspaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String kind,
    bool isArchived,
    String defaultCurrency,
    String? locale,
    String? taxJurisdiction,
    String? icon,
    String? color,
    String? createdAt,
    String? createdByUserId,
    String? managedByUserId,
    WorkspaceRole? role,
    List<String> enabledModules,
  });
}

/// @nodoc
class __$$WorkspaceImplCopyWithImpl<$Res>
    extends _$WorkspaceCopyWithImpl<$Res, _$WorkspaceImpl>
    implements _$$WorkspaceImplCopyWith<$Res> {
  __$$WorkspaceImplCopyWithImpl(
    _$WorkspaceImpl _value,
    $Res Function(_$WorkspaceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? kind = null,
    Object? isArchived = null,
    Object? defaultCurrency = null,
    Object? locale = freezed,
    Object? taxJurisdiction = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? createdAt = freezed,
    Object? createdByUserId = freezed,
    Object? managedByUserId = freezed,
    Object? role = freezed,
    Object? enabledModules = null,
  }) {
    return _then(
      _$WorkspaceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        defaultCurrency: null == defaultCurrency
            ? _value.defaultCurrency
            : defaultCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        locale: freezed == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxJurisdiction: freezed == taxJurisdiction
            ? _value.taxJurisdiction
            : taxJurisdiction // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdByUserId: freezed == createdByUserId
            ? _value.createdByUserId
            : createdByUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        managedByUserId: freezed == managedByUserId
            ? _value.managedByUserId
            : managedByUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as WorkspaceRole?,
        enabledModules: null == enabledModules
            ? _value._enabledModules
            : enabledModules // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceImpl extends _Workspace {
  const _$WorkspaceImpl({
    required this.id,
    required this.name,
    required this.kind,
    this.isArchived = false,
    required this.defaultCurrency,
    this.locale,
    this.taxJurisdiction,
    this.icon,
    this.color,
    this.createdAt,
    this.createdByUserId,
    this.managedByUserId,
    this.role,
    final List<String> enabledModules = const <String>[],
  }) : _enabledModules = enabledModules,
       super._();

  factory _$WorkspaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  /// Widened to a plain String on purpose, matching the web types: a
  /// workspace stored before the current kind list still has to render.
  @override
  final String kind;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  final String defaultCurrency;
  @override
  final String? locale;
  @override
  final String? taxJurisdiction;
  @override
  final String? icon;
  @override
  final String? color;
  @override
  final String? createdAt;
  @override
  final String? createdByUserId;
  @override
  final String? managedByUserId;
  @override
  final WorkspaceRole? role;

  /// Modules this workspace shows. Resolved server-side — the app never
  /// decides this locally, or the two copies drift and the user sees a
  /// module the server thinks is off.
  final List<String> _enabledModules;

  /// Modules this workspace shows. Resolved server-side — the app never
  /// decides this locally, or the two copies drift and the user sees a
  /// module the server thinks is off.
  @override
  @JsonKey()
  List<String> get enabledModules {
    if (_enabledModules is EqualUnmodifiableListView) return _enabledModules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enabledModules);
  }

  @override
  String toString() {
    return 'Workspace(id: $id, name: $name, kind: $kind, isArchived: $isArchived, defaultCurrency: $defaultCurrency, locale: $locale, taxJurisdiction: $taxJurisdiction, icon: $icon, color: $color, createdAt: $createdAt, createdByUserId: $createdByUserId, managedByUserId: $managedByUserId, role: $role, enabledModules: $enabledModules)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.defaultCurrency, defaultCurrency) ||
                other.defaultCurrency == defaultCurrency) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.taxJurisdiction, taxJurisdiction) ||
                other.taxJurisdiction == taxJurisdiction) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdByUserId, createdByUserId) ||
                other.createdByUserId == createdByUserId) &&
            (identical(other.managedByUserId, managedByUserId) ||
                other.managedByUserId == managedByUserId) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality().equals(
              other._enabledModules,
              _enabledModules,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    kind,
    isArchived,
    defaultCurrency,
    locale,
    taxJurisdiction,
    icon,
    color,
    createdAt,
    createdByUserId,
    managedByUserId,
    role,
    const DeepCollectionEquality().hash(_enabledModules),
  );

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceImplCopyWith<_$WorkspaceImpl> get copyWith =>
      __$$WorkspaceImplCopyWithImpl<_$WorkspaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceImplToJson(this);
  }
}

abstract class _Workspace extends Workspace {
  const factory _Workspace({
    required final String id,
    required final String name,
    required final String kind,
    final bool isArchived,
    required final String defaultCurrency,
    final String? locale,
    final String? taxJurisdiction,
    final String? icon,
    final String? color,
    final String? createdAt,
    final String? createdByUserId,
    final String? managedByUserId,
    final WorkspaceRole? role,
    final List<String> enabledModules,
  }) = _$WorkspaceImpl;
  const _Workspace._() : super._();

  factory _Workspace.fromJson(Map<String, dynamic> json) =
      _$WorkspaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Widened to a plain String on purpose, matching the web types: a
  /// workspace stored before the current kind list still has to render.
  @override
  String get kind;
  @override
  bool get isArchived;
  @override
  String get defaultCurrency;
  @override
  String? get locale;
  @override
  String? get taxJurisdiction;
  @override
  String? get icon;
  @override
  String? get color;
  @override
  String? get createdAt;
  @override
  String? get createdByUserId;
  @override
  String? get managedByUserId;
  @override
  WorkspaceRole? get role;

  /// Modules this workspace shows. Resolved server-side — the app never
  /// decides this locally, or the two copies drift and the user sees a
  /// module the server thinks is off.
  @override
  List<String> get enabledModules;

  /// Create a copy of Workspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceImplCopyWith<_$WorkspaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspaceMember _$WorkspaceMemberFromJson(Map<String, dynamic> json) {
  return _WorkspaceMember.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceMember {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  WorkspaceRole get role => throw _privateConstructorUsedError;
  String? get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceMemberCopyWith<WorkspaceMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceMemberCopyWith<$Res> {
  factory $WorkspaceMemberCopyWith(
    WorkspaceMember value,
    $Res Function(WorkspaceMember) then,
  ) = _$WorkspaceMemberCopyWithImpl<$Res, WorkspaceMember>;
  @useResult
  $Res call({
    String id,
    String userId,
    String email,
    String? displayName,
    WorkspaceRole role,
    String? joinedAt,
  });
}

/// @nodoc
class _$WorkspaceMemberCopyWithImpl<$Res, $Val extends WorkspaceMember>
    implements $WorkspaceMemberCopyWith<$Res> {
  _$WorkspaceMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? role = null,
    Object? joinedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as WorkspaceRole,
            joinedAt: freezed == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkspaceMemberImplCopyWith<$Res>
    implements $WorkspaceMemberCopyWith<$Res> {
  factory _$$WorkspaceMemberImplCopyWith(
    _$WorkspaceMemberImpl value,
    $Res Function(_$WorkspaceMemberImpl) then,
  ) = __$$WorkspaceMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String email,
    String? displayName,
    WorkspaceRole role,
    String? joinedAt,
  });
}

/// @nodoc
class __$$WorkspaceMemberImplCopyWithImpl<$Res>
    extends _$WorkspaceMemberCopyWithImpl<$Res, _$WorkspaceMemberImpl>
    implements _$$WorkspaceMemberImplCopyWith<$Res> {
  __$$WorkspaceMemberImplCopyWithImpl(
    _$WorkspaceMemberImpl _value,
    $Res Function(_$WorkspaceMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? role = null,
    Object? joinedAt = freezed,
  }) {
    return _then(
      _$WorkspaceMemberImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as WorkspaceRole,
        joinedAt: freezed == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceMemberImpl implements _WorkspaceMember {
  const _$WorkspaceMemberImpl({
    required this.id,
    required this.userId,
    required this.email,
    this.displayName,
    required this.role,
    this.joinedAt,
  });

  factory _$WorkspaceMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final WorkspaceRole role;
  @override
  final String? joinedAt;

  @override
  String toString() {
    return 'WorkspaceMember(id: $id, userId: $userId, email: $email, displayName: $displayName, role: $role, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, email, displayName, role, joinedAt);

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceMemberImplCopyWith<_$WorkspaceMemberImpl> get copyWith =>
      __$$WorkspaceMemberImplCopyWithImpl<_$WorkspaceMemberImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceMemberImplToJson(this);
  }
}

abstract class _WorkspaceMember implements WorkspaceMember {
  const factory _WorkspaceMember({
    required final String id,
    required final String userId,
    required final String email,
    final String? displayName,
    required final WorkspaceRole role,
    final String? joinedAt,
  }) = _$WorkspaceMemberImpl;

  factory _WorkspaceMember.fromJson(Map<String, dynamic> json) =
      _$WorkspaceMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  WorkspaceRole get role;
  @override
  String? get joinedAt;

  /// Create a copy of WorkspaceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceMemberImplCopyWith<_$WorkspaceMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
