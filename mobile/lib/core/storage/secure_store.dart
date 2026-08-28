import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persistent client state.
///
/// The web app keeps the JWT and the active workspace in `localStorage`. On a
/// device that is the wrong home for a bearer token, so both live in the
/// Android Keystore instead. The key names match the web ones so the mental
/// model carries over.
class SecureStore {
  SecureStore([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'token';
  static const _workspaceKey = 'workspace_id';
  static const _baseUrlKey = 'base_url';
  static const _emailKey = 'saved_email';
  static const _passwordKey = 'saved_password';
  static const _biometricsKey = 'biometrics_enabled';

  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<String?> readWorkspaceId() => _storage.read(key: _workspaceKey);
  Future<void> writeWorkspaceId(String id) =>
      _storage.write(key: _workspaceKey, value: id);
  Future<void> clearWorkspaceId() => _storage.delete(key: _workspaceKey);

  Future<String?> readBaseUrl() => _storage.read(key: _baseUrlKey);
  Future<void> writeBaseUrl(String url) =>
      _storage.write(key: _baseUrlKey, value: url);

  /// Credentials are stored only when the user opts into biometric unlock.
  /// They exist to paper over the backend's 24h token lifetime: on expiry the
  /// app re-authenticates silently behind a fingerprint prompt rather than
  /// bouncing the user to a login form once a day.
  Future<({String email, String password})?> readCredentials() async {
    final email = await _storage.read(key: _emailKey);
    final password = await _storage.read(key: _passwordKey);
    if (email == null || password == null) return null;
    return (email: email, password: password);
  }

  Future<void> writeCredentials(String email, String password) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }

  Future<bool> readBiometricsEnabled() async =>
      await _storage.read(key: _biometricsKey) == 'true';
  Future<void> writeBiometricsEnabled(bool enabled) =>
      _storage.write(key: _biometricsKey, value: enabled.toString());

  /// Wipes everything a sign-out should not survive. The base URL is kept so
  /// the user does not retype their server address on every logout.
  Future<void> clearSession() async {
    await clearToken();
    await clearWorkspaceId();
    await clearCredentials();
    await _storage.delete(key: _biometricsKey);
  }
}
