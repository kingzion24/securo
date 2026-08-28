// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$UserPreferencesImpl(
  language: json['language'] as String?,
  dateFormat: json['date_format'] as String?,
  timezone: json['timezone'] as String?,
  currencyDisplay: json['currency_display'] as String?,
  displayName: json['display_name'] as String?,
  onboardingCompleted: json['onboarding_completed'] as bool?,
  idleLockMinutes: (json['idle_lock_minutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$$UserPreferencesImplToJson(
  _$UserPreferencesImpl instance,
) => <String, dynamic>{
  'language': instance.language,
  'date_format': instance.dateFormat,
  'timezone': instance.timezone,
  'currency_display': instance.currencyDisplay,
  'display_name': instance.displayName,
  'onboarding_completed': instance.onboardingCompleted,
  'idle_lock_minutes': instance.idleLockMinutes,
};

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  isActive: json['is_active'] as bool,
  isSuperuser: json['is_superuser'] as bool,
  isVerified: json['is_verified'] as bool,
  is2faEnabled: json['is_2fa_enabled'] as bool,
  preferences: json['preferences'] == null
      ? const UserPreferences()
      : UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'is_active': instance.isActive,
      'is_superuser': instance.isSuperuser,
      'is_verified': instance.isVerified,
      'is_2fa_enabled': instance.is2faEnabled,
      'preferences': instance.preferences.toJson(),
    };
