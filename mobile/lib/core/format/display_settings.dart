import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/workspace/workspace_controller.dart';

/// The one place that decides "what currency do we show a total in" and
/// "what locale do we format numbers/dates with" — every screen reads these
/// two instead of hardcoding a currency or guessing a locale, so a change to
/// Settings is felt everywhere at once, exactly like the web app's
/// `user.preferences.currency_display` / workspace locale.
final displayCurrencyProvider = Provider<String>((ref) {
  final userCurrency =
      ref.watch(authControllerProvider).user?.preferences.currencyDisplay;
  if (userCurrency != null && userCurrency.isNotEmpty) return userCurrency;
  final workspaceCurrency =
      ref.watch(currentWorkspaceProvider).valueOrNull?.defaultCurrency;
  return workspaceCurrency ?? 'USD';
});

final displayLocaleProvider = Provider<String?>((ref) {
  return ref.watch(currentWorkspaceProvider).valueOrNull?.locale;
});
