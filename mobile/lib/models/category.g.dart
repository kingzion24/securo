// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      groupId: json['group_id'] as String?,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      color: json['color'] as String? ?? '',
      isSystem: json['is_system'] as bool? ?? false,
      isHidden: json['is_hidden'] as bool? ?? false,
      treatAsTransfer: json['treat_as_transfer'] as bool? ?? false,
      isIgnored: json['is_ignored'] as bool? ?? false,
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'is_system': instance.isSystem,
      'is_hidden': instance.isHidden,
      'treat_as_transfer': instance.treatAsTransfer,
      'is_ignored': instance.isIgnored,
    };

_$CategoryGroupImpl _$$CategoryGroupImplFromJson(Map<String, dynamic> json) =>
    _$CategoryGroupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      color: json['color'] as String? ?? '',
      position: (json['position'] as num?)?.toInt() ?? 0,
      isSystem: json['is_system'] as bool? ?? false,
      isHidden: json['is_hidden'] as bool? ?? false,
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Category>[],
    );

Map<String, dynamic> _$$CategoryGroupImplToJson(_$CategoryGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'position': instance.position,
      'is_system': instance.isSystem,
      'is_hidden': instance.isHidden,
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };
