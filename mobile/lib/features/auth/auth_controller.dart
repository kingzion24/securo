import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/providers.dart';
import '../../models/user.dart';
import 'auth_repository.dart';
import 'passkey_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider)),
);

final passkeyRepositoryProvider = Provider<PasskeyRepository>(
  (ref) => PasskeyRepository(ref.watch(apiClientProvider)),
);

final localAuthProvider = Provider<LocalAuthentication>(
  (ref) => LocalAuthentication(),
);

enum AuthStatus {
  /// Reading stored credentials at startup; show a splash, not a login form.
  restoring,
  unauthenticated,

  /// Signed in, but the app has been idle past the lock timeout.
  locked,
  authenticated,
}

@immutable
class AuthState {
  const AuthState({
    this.status = AuthStatus.restoring,
    this.user,
    this.features = const {},
    this.pending2fa,
  });

  final AuthStatus status;
  final User? user;
  final Map<String, bool> features;

  /// Set while a login is parked waiting on a second factor.
  final LoginNeeds2fa? pending2fa;

  bool get isAgentsEnabled => features['agents'] ?? false;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    Map<String, bool>? features,
    LoginNeeds2fa? pending2fa,
    bool clearPending2fa = false,
    bool clearUser = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: clearUser ? null : (user ?? this.user),
        features: features ?? this.features,
        pending2fa: clearPending2fa ? null : (pending2fa ?? this.pending2fa),
      );
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState());

  final Ref _ref;

  AuthRepository get _repo => _ref.read(authRepositoryProvider);

  /// Restores a session at launch: point the client at the saved server, then
  /// try the stored token. A token that the server no longer accepts falls
  /// through to a silent re-login when biometrics are set up.
  Future<void> restore() async {
    final store = _ref.read(secureStoreProvider);
    final api = _ref.read(apiClientProvider);

    // The store is the source of truth: setServerOrigin always writes there,
    // so an unset value means the user has never overridden the default.
    final String origin = await store.readBaseUrl() ?? kDefaultBaseUrl;
    _ref.read(baseUrlProvider.notifier).state = origin;
    api.setOrigin(origin);

    final token = await store.readToken();
    if (token == null) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    try {
      final user = await _repo.me();
      final features = await _repo.features();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        features: features,
      );
    } on ApiException catch (error) {
      if (error.isUnauthorized && await _silentReLogin()) return;
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// The backend issues a 24h JWT and has no refresh endpoint. Rather than
  /// dumping the user at a login form once a day, the app re-authenticates
  /// with the credentials it stored when they opted into biometrics.
  Future<bool> _silentReLogin() async {
    final store = _ref.read(secureStoreProvider);
    if (!await store.readBiometricsEnabled()) return false;

    final credentials = await store.readCredentials();
    if (credentials == null) return false;

    try {
      final result = await _repo.login(credentials.email, credentials.password);
      // A 2FA-protected account cannot be re-established without the user, so
      // fall back to the login screen.
      if (result is! LoginSuccess) return false;

      await store.writeToken(result.accessToken);
      final user = await _repo.me();
      final features = await _repo.features();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        features: features,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns true when signed in, false when a second factor is still needed
  /// (in which case `state.pending2fa` describes the challenge).
  Future<bool> login({
    required String email,
    required String password,
    bool rememberForBiometrics = false,
  }) async {
    final result = await _repo.login(email, password);

    if (result is LoginNeeds2fa) {
      // Held so the 2FA screen can finish what this login started, and so a
      // successful verify knows whether to persist credentials.
      _pendingCredentials =
          rememberForBiometrics ? (email: email, password: password) : null;
      state = state.copyWith(pending2fa: result);
      return false;
    }

    await _completeLogin(
      (result as LoginSuccess).accessToken,
      credentials: rememberForBiometrics
          ? (email: email, password: password)
          : null,
    );
    return true;
  }

  ({String email, String password})? _pendingCredentials;

  Future<void> verifyTotp(String code) async {
    final pending = state.pending2fa;
    if (pending == null) {
      throw ApiException('This sign-in attempt expired. Try again.');
    }
    final token = await _repo.verifyTotp(
      tempToken: pending.tempToken,
      code: code,
    );
    await _completeLogin(token, credentials: _pendingCredentials);
  }

  /// Finishes a sign-in from any path — password, 2FA, or a token handed back
  /// by the OIDC/passkey browser flow.
  Future<void> completeWithToken(String token) => _completeLogin(token);

  Future<void> _completeLogin(
    String token, {
    ({String email, String password})? credentials,
  }) async {
    final store = _ref.read(secureStoreProvider);
    await store.writeToken(token);

    if (credentials != null) {
      await store.writeCredentials(credentials.email, credentials.password);
      await store.writeBiometricsEnabled(true);
    }
    _pendingCredentials = null;

    final user = await _repo.me();
    final features = await _repo.features();
    state = AuthState(
      status: AuthStatus.authenticated,
      user: user,
      features: features,
    );
  }

  void cancel2fa() => state = state.copyWith(clearPending2fa: true);

  /// Marks the session locked after the idle timeout. The token is kept — the
  /// user is proving it is still them, not signing in again.
  void lock() {
    if (state.status == AuthStatus.authenticated) {
      state = state.copyWith(status: AuthStatus.locked);
    }
  }

  void unlock() {
    if (state.status == AuthStatus.locked) {
      state = state.copyWith(status: AuthStatus.authenticated);
    }
  }

  Future<bool> authenticateWithBiometrics({
    String reason = 'Unlock Securo',
  }) async {
    final auth = _ref.read(localAuthProvider);
    try {
      if (!await auth.isDeviceSupported()) return false;
      return await auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> canUseBiometrics() async {
    final auth = _ref.read(localAuthProvider);
    try {
      return await auth.isDeviceSupported() &&
          await auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<void> setServerOrigin(String origin) async {
    final store = _ref.read(secureStoreProvider);
    await store.writeBaseUrl(origin);
    _ref.read(baseUrlProvider.notifier).state = origin;
    _ref.read(apiClientProvider).setOrigin(origin);
  }

  Future<void> logout() async {
    await _repo.logout();
    await _ref.read(secureStoreProvider).clearSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Called by the API client's 401 handler.
  void onUnauthorized() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> refreshUser() async {
    try {
      state = state.copyWith(user: await _repo.me());
    } catch (_) {
      // A transient failure here should not tear down the session.
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final controller = AuthController(ref);
  ref.watch(unauthorizedSignalProvider).addListener(controller.onUnauthorized);
  return controller;
});
