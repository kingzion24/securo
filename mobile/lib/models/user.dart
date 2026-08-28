import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Mirrors `UserPreferences` in `frontend/src/types/index.ts`.
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    String? language,
    String? dateFormat,
    String? timezone,
    String? currencyDisplay,
    String? displayName,
    bool? onboardingCompleted,

    /// Minutes of inactivity before the lock screen appears. 0 disables it.
    /// The web app defaults this to 5 when unset; [idleLockMinutesOrDefault]
    /// keeps that behaviour in one place.
    int? idleLockMinutes,
  }) = _UserPreferences;

  const UserPreferences._();

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  int get idleLockMinutesOrDefault => idleLockMinutes ?? 5;
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required bool isActive,
    required bool isSuperuser,
    required bool isVerified,
    @JsonKey(name: 'is_2fa_enabled') required bool is2faEnabled,
    @Default(UserPreferences()) UserPreferences preferences,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// What to show in the account menu: the chosen display name, else the
  /// local part of the email.
  String get label {
    final name = preferences.displayName;
    if (name != null && name.trim().isNotEmpty) return name.trim();
    return email.split('@').first;
  }
}
