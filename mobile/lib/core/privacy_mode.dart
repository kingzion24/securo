import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPrivacyModeKey = 'securo.privacy_mode';
const kPrivacyMask = '•••••';

/// Mirrors the web app's `usePrivacyMode` hook: a device-local toggle that
/// masks money amounts on screen (for a crowded train, a screen-share, a
/// shoulder-surfer) without hiding the underlying data from the app itself.
class PrivacyModeController extends Notifier<bool> {
  @override
  bool build() {
    _restore();
    return false;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool(_kPrivacyModeKey) ?? false;
    if (stored != state) state = stored;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPrivacyModeKey, state);
  }
}

final privacyModeProvider = NotifierProvider<PrivacyModeController, bool>(
  PrivacyModeController.new,
);
