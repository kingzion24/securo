package com.zion24.securo

import android.content.pm.PackageManager
import android.content.pm.Signature
import java.security.MessageDigest
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// local_auth's biometric prompt is a FragmentActivity API, so the host
// activity has to be a FlutterFragmentActivity rather than FlutterActivity.
class MainActivity : FlutterFragmentActivity() {
    private val channelName = "com.zion24.securo/app_signature"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            if (call.method == "sha256CertFingerprint") {
                val fingerprint = signingCertSha256Fingerprint()
                if (fingerprint != null) {
                    result.success(fingerprint)
                } else {
                    result.error("signature_unavailable", "Could not read the app's signing certificate.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Colon-separated uppercase hex, matching what `keytool -list -v` prints —
    // the form WEBAUTHN_ANDROID_CERT_FINGERPRINTS is configured with, so a
    // fingerprint copied from either place is directly comparable.
    private fun signingCertSha256Fingerprint(): String? {
        val signatures: Array<Signature>? =
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                val info = packageManager.getPackageInfo(
                    packageName,
                    PackageManager.GET_SIGNING_CERTIFICATES,
                )
                val signingInfo = info.signingInfo ?: return null
                if (signingInfo.hasMultipleSigners()) {
                    signingInfo.apkContentsSigners
                } else {
                    signingInfo.signingCertificateHistory
                }
            } else {
                @Suppress("DEPRECATION")
                val info = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
                @Suppress("DEPRECATION")
                info.signatures
            }
        val signature = signatures?.firstOrNull() ?: return null
        val digest = MessageDigest.getInstance("SHA-256").digest(signature.toByteArray())
        return digest.joinToString(":") { "%02X".format(it) }
    }
}
