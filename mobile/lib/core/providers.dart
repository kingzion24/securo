import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api/api_client.dart';
import 'storage/secure_store.dart';

/// Broadcasts "the server rejected our token". The router listens and sends
/// the user to /login, which is this app's equivalent of the web response
/// interceptor's `window.location.href = '/login'`.
class UnauthorizedSignal extends ChangeNotifier {
  void trigger() => notifyListeners();
}

final unauthorizedSignalProvider = Provider<UnauthorizedSignal>((ref) {
  final signal = UnauthorizedSignal();
  ref.onDispose(signal.dispose);
  return signal;
});

final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());

final apiClientProvider = Provider<ApiClient>((ref) {
  final signal = ref.watch(unauthorizedSignalProvider);
  final client = ApiClient(store: ref.watch(secureStoreProvider));
  client.onUnauthorized = signal.trigger;
  return client;
});

/// The server origin (scheme + host, no `/api` suffix). Seeded at startup from
/// secure storage, falling back to the bundled default.
final baseUrlProvider = StateProvider<String>((ref) => kDefaultBaseUrl);
