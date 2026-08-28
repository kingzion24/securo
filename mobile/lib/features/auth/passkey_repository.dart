import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';

import '../../core/api/api_client.dart';
import '../../core/platform/android_app_signature.dart';

/// Drives passkey registration and sign-in through the device's native
/// Credential Manager (Android) — no browser tab.
///
/// The server (`backend/app/api/passkeys.py`) speaks standard WebAuthn JSON
/// via the `webauthn` Python library, and this plugin's request/response
/// types serialise to and from that same shape, so the options the server
/// returns are handed to the plugin almost unchanged, and the plugin's result
/// is handed back to the server the same way.
class PasskeyRepository {
  PasskeyRepository(this._api);

  final ApiClient _api;
  final _authenticator = PasskeyAuthenticator();

  /// The `Origin` header the app sends on passkey calls so the server knows,
  /// before it generates a challenge, to expect the native Android origin
  /// back rather than an https one. Null (and therefore omitted) on
  /// platforms other than Android, or if it could not be determined —
  /// resolve_webauthn_context then falls back to browser-origin handling,
  /// which fails cleanly with a clear error rather than a silent mismatch.
  Future<Map<String, String>?> _originHeader() async {
    final origin = await AndroidAppSignature.passkeyOrigin();
    return origin == null ? null : {'Origin': origin};
  }

  Future<void> register({String name = 'Passkey'}) async {
    final headers = await _originHeader();
    final optionsResponse = await _api.post<Map<String, dynamic>>(
      '/passkeys/register/options',
      body: {'name': name},
      headers: headers,
    );
    final challengeId = optionsResponse['challenge_id'] as String;
    final options = optionsResponse['options'] as Map<String, dynamic>;

    final registration = await _authenticator.register(
      RegisterRequestType.fromJson(options),
    );

    await _api.post<Map<String, dynamic>>(
      '/passkeys/register/verify',
      body: {
        'challenge_id': challengeId,
        'name': name,
        'credential': registration.toJson(),
      },
      headers: headers,
    );
  }

  /// Signs in with a discoverable passkey (the account picker is shown by the
  /// OS, so no email is collected first). Returns the bearer token.
  Future<String> signIn() async {
    final headers = await _originHeader();
    final optionsResponse = await _api.post<Map<String, dynamic>>(
      '/passkeys/authenticate/options',
      body: <String, dynamic>{},
      headers: headers,
    );
    final challengeId = optionsResponse['challenge_id'] as String;
    final options = optionsResponse['options'] as Map<String, dynamic>;

    final assertion = await _authenticator.authenticate(
      AuthenticateRequestType.fromJson(options),
    );

    final verifyResponse = await _api.post<Map<String, dynamic>>(
      '/passkeys/authenticate/verify',
      body: {
        'challenge_id': challengeId,
        'credential': assertion.toJson(),
      },
      headers: headers,
    );
    return verifyResponse['access_token'] as String;
  }
}
