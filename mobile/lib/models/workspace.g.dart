// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceImpl _$$WorkspaceImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String,
      isArchived: json['is_archived'] as bool? ?? false,
      defaultCurrency: json['default_currency'] as String,
      locale: json['locale'] as String?,
      taxJurisdiction: json['tax_jurisdiction'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      createdAt: json['created_at'] as String?,
      createdByUserId: json['created_by_user_id'] as String?,
      managedByUserId: json['managed_by_user_id'] as String?,
      role: $enumDecodeNullable(_$WorkspaceRoleEnumMap, json['role']),
      enabledModules:
          (json['enabled_modules'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$WorkspaceImplToJson(_$WorkspaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': instance.kind,
      'is_archived': instance.isArchived,
      'default_currency': instance.defaultCurrency,
      'locale': instance.locale,
      'tax_jurisdiction': instance.taxJurisdiction,
      'icon': instance.icon,
      'color': instance.color,
      'created_at': instance.createdAt,
      'created_by_user_id': instance.createdByUserId,
      'managed_by_user_id': instance.managedByUserId,
      'role': _$WorkspaceRoleEnumMap[instance.role],
      'enabled_modules': instance.enabledModules,
    };

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.owner: 'owner',
  WorkspaceRole.editor: 'editor',
  WorkspaceRole.viewer: 'viewer',
  WorkspaceRole.manager: 'manager',
};

_$WorkspaceMemberImpl _$$WorkspaceMemberImplFromJson(
  Map<String, dynamic> json,
) => _$WorkspaceMemberImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String?,
  role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
  joinedAt: json['joined_at'] as String?,
);

Map<String, dynamic> _$$WorkspaceMemberImplToJson(
  _$WorkspaceMemberImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'email': instance.email,
  'display_name': instance.displayName,
  'role': _$WorkspaceRoleEnumMap[instance.role]!,
  'joined_at': instance.joinedAt,
};
