import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

/// Sign-in paths that have to run in a real browser rather than in-app.
///
/// Passkeys are not here — they run through Android's native Credential
/// Manager instead (`passkey_repository.dart`), with no browser involved.
enum BrowserAuthKind { oidc }

/// Custom scheme the Android manifest registers on MainActivity. The web app
/// redirects here once it holds a token.
const kAuthCallbackScheme = 'securo';

/// Runs OIDC sign-in through an external browser tab.
///
/// The provider's consent page must be shown somewhere the user can trust,
/// and the backend drives state/PKCE itself — it finishes by redirecting to
/// `{frontend_url}/auth/oidc/callback#access_token=...`, which is bounced on
/// again to `securo://auth`.
///
/// Returns the bearer token, or null if the user backed out.
Future<String?> signInViaBrowser({
  required BrowserAuthKind kind,
  required String origin,
  Duration timeout = const Duration(minutes: 5),
}) async {
  final base = origin.replaceAll(RegExp(r'/+$'), '');
  final callback = '$kAuthCallbackScheme://auth';

  // `redirect_to` tells the web app where to bounce once it holds a token.
  final url =
      '$base/api/auth/oidc/login?redirect_to=${Uri.encodeComponent(callback)}';

  final links = AppLinks();

  // Subscribe before launching, so a fast redirect cannot land before the
  // listener is attached.
  final completer = Completer<String?>();
  late final StreamSubscription<Uri> subscription;
  subscription = links.uriLinkStream.listen((uri) {
    if (uri.scheme != kAuthCallbackScheme) return;
    if (!completer.isCompleted) completer.complete(_tokenFrom(uri));
  });

  try {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) return null;

    // A user who abandons the browser never sends a callback, so the wait is
    // bounded rather than leaking a pending future for the session's lifetime.
    return await completer.future.timeout(timeout, onTimeout: () => null);
  } finally {
    await subscription.cancel();
  }
}

/// The backend hands the token back on the URL fragment
/// (`#access_token=...&token_type=bearer`); some paths use a query string
/// instead, so both are checked.
String? _tokenFrom(Uri uri) {
  final fromQuery = uri.queryParameters['access_token'];
  if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;

  if (uri.fragment.isEmpty) return null;
  final token = Uri.splitQueryString(uri.fragment)['access_token'];
  return (token == null || token.isEmpty) ? null : token;
}
