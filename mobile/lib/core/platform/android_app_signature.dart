import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

/// The origin Android's Credential Manager embeds in a passkey ceremony's
/// `clientDataJSON` — `android:apk-key-hash:<hash of this build's signing
/// cert>`. The backend needs this in advance (see
/// `backend/app/core/webauthn.py`) to store the right expected origin
/// alongside the challenge, so it is read from the installed APK itself
/// rather than hardcoded — debug and release builds sign with different
/// certs and both need to work unmodified.
class AndroidAppSignature {
  AndroidAppSignature._();

  static const _channel = MethodChannel('com.zion24.securo/app_signature');
  static String? _cachedOrigin;

  /// Null on any platform other than Android, or if the signing certificate
  /// could not be read.
  static Future<String?> passkeyOrigin() async {
    if (!Platform.isAndroid) return null;
    final cached = _cachedOrigin;
    if (cached != null) return cached;

    try {
      final fingerprint =
          await _channel.invokeMethod<String>('sha256CertFingerprint');
      if (fingerprint == null) return null;
      final bytes = fingerprint
          .split(':')
          .map((hex) => int.parse(hex, radix: 16))
          .toList();
      final hash = base64Url.encode(bytes).replaceAll('=', '');
      return _cachedOrigin = 'android:apk-key-hash:$hash';
    } on PlatformException {
      return null;
    }
  }
}
