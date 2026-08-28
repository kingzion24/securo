import '../../core/api/api_client.dart';
import '../../models/user.dart';

/// What `POST /api/auth/login` returned.
///
/// The endpoint has two shapes: a token on success, or a 2FA challenge with a
/// temp token that must be exchanged at `/auth/2fa/verify`.
sealed class LoginResult {
  const LoginResult();
}

class LoginSuccess extends LoginResult {
  const LoginSuccess(this.accessToken);
  final String accessToken;
}

class LoginNeeds2fa extends LoginResult {
  const LoginNeeds2fa({required this.tempToken, required this.methods});
  final String tempToken;

  /// e.g. `['totp', 'passkey']` — decides which second-factor UI to show.
  final List<String> methods;

  bool get hasTotp => methods.contains('totp');
  bool get hasPasskey => methods.contains('passkey');
}

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  /// The backend takes an OAuth2 password form, not JSON, and names the
  /// email field `username`.
  Future<LoginResult> login(String email, String password) async {
    final data = await _api.postForm<Map<String, dynamic>>(
      '/auth/login',
      {'username': email, 'password': password},
    );

    if (data['requires_2fa'] == true) {
      return LoginNeeds2fa(
        tempToken: data['temp_token'] as String,
        methods: (data['available_methods'] as List?)?.cast<String>() ??
            const ['totp'],
      );
    }
    return LoginSuccess(data['access_token'] as String);
  }

  /// Exchanges a TOTP code plus the temp token from [LoginNeeds2fa] for a JWT.
  Future<String> verifyTotp({
    required String tempToken,
    required String code,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/auth/2fa/verify',
      body: {'temp_token': tempToken, 'code': code},
    );
    return data['access_token'] as String;
  }

  Future<User> me() async {
    final data = await _api.get<Map<String, dynamic>>('/users/me');
    return User.fromJson(data);
  }

  Future<User> updatePreferences(UserPreferences preferences) async {
    final data = await _api.patch<Map<String, dynamic>>(
      '/users/me',
      body: {'preferences': preferences.toJson()},
    );
    return User.fromJson(data);
  }

  /// Whether this deployment offers OIDC, and under what button label.
  Future<({bool enabled, String providerName})> oidcConfig() async {
    try {
      final data = await _api.get<Map<String, dynamic>>('/auth/oidc/config');
      return (
        enabled: data['enabled'] == true,
        providerName: data['provider_name'] as String? ?? 'OIDC',
      );
    } catch (_) {
      // A deployment with OIDC compiled out answers 404 here; that is a
      // "no button", not an error worth surfacing.
      return (enabled: false, providerName: 'OIDC');
    }
  }

  /// Feature flags from `/api/info`. The web app gates the Agents nav on this;
  /// the mobile nav does the same rather than hardcoding a guess.
  Future<Map<String, bool>> features() async {
    try {
      final data = await _api.get<Map<String, dynamic>>('/info');
      final features = data['features'] as Map<String, dynamic>? ?? {};
      return {
        for (final e in features.entries) e.key: e.value == true,
      };
    } catch (_) {
      return const {};
    }
  }

  Future<void> logout() async {
    try {
      await _api.post<dynamic>('/auth/logout');
    } catch (_) {
      // A already-expired token makes logout 401. The local session is being
      // dropped regardless, so this is not worth reporting.
    }
  }
}
