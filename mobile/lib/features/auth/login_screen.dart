import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/api/api_exception.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import 'auth_controller.dart';
import 'browser_auth.dart';
import 'server_dialog.dart';
import 'two_factor_sheet.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _submitting = false;
  bool _obscure = true;
  bool _rememberBiometrics = false;
  bool _biometricsAvailable = false;
  String? _error;

  ({bool enabled, String providerName}) _oidc =
      (enabled: false, providerName: 'OIDC');

  @override
  void initState() {
    super.initState();
    _loadServerCapabilities();
  }

  /// Which sign-in buttons to offer is the server's call, not a build-time
  /// constant — the same APK has to work against a deployment with OIDC on and
  /// one with it off.
  Future<void> _loadServerCapabilities() async {
    final controller = ref.read(authControllerProvider.notifier);
    final oidc = await ref.read(authRepositoryProvider).oidcConfig();
    final biometrics = await controller.canUseBiometrics();
    if (!mounted) return;
    setState(() {
      _oidc = oidc;
      _biometricsAvailable = biometrics;
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final signedIn =
          await ref.read(authControllerProvider.notifier).login(
                email: _email.text.trim(),
                password: _password.text,
                rememberForBiometrics: _rememberBiometrics,
              );

      // Not signed in means a second factor is outstanding; the sheet below
      // finishes the flow and the router redirects on success.
      if (!signedIn && mounted) {
        await showTwoFactorSheet(context);
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// OIDC runs in a Chrome Custom Tab against the real web origin, then hands
  /// the token back. See `browser_auth.dart` for why — a third-party login
  /// page has to be shown somewhere the user can trust.
  Future<void> _oidcSignIn() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final token = await signInViaBrowser(
        kind: BrowserAuthKind.oidc,
        origin: ref.read(baseUrlProvider),
      );
      if (token == null) return;
      await ref.read(authControllerProvider.notifier).completeWithToken(token);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (error) {
      if (mounted) setState(() => _error = '$error');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Passkeys run entirely on-device through Android's Credential Manager —
  /// no browser tab. See `passkey_repository.dart`.
  Future<void> _passkeySignIn() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final token = await ref.read(passkeyRepositoryProvider).signIn();
      await ref.read(authControllerProvider.notifier).completeWithToken(token);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (error) {
      // Includes PasskeyAuthCancelledException from a user backing out of the
      // system prompt — not worth alarming copy, but still needs the spinner
      // to clear and the button to work again.
      if (mounted) setState(() => _error = '$error');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;
    final origin = ref.watch(baseUrlProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        width: 56,
                        height: 56,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: text.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to your Securo workspace',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (_error != null) ...[
                      _ErrorBanner(message: _error!),
                      const SizedBox(height: 16),
                    ],
                    _Label('Email'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.next,
                      enabled: !_submitting,
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Enter your email'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    _Label('Password'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      enabled: !_submitting,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: colors.mutedForeground,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Enter your password'
                          : null,
                    ),
                    if (_biometricsAvailable) ...[
                      const SizedBox(height: 8),
                      _BiometricOptIn(
                        value: _rememberBiometrics,
                        onChanged: _submitting
                            ? null
                            : (v) => setState(() => _rememberBiometrics = v),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign in'),
                    ),
                    const SizedBox(height: 16),
                    _Divider(label: 'or'),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _submitting ? null : _passkeySignIn,
                      icon: const Icon(Icons.fingerprint, size: 20),
                      label: const Text('Sign in with a passkey'),
                    ),
                    if (_oidc.enabled) ...[
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _submitting ? null : _oidcSignIn,
                        icon: const Icon(Icons.shield_outlined, size: 20),
                        label: Text('Continue with ${_oidc.providerName}'),
                      ),
                    ],
                    const SizedBox(height: 28),
                    _ServerRow(
                      origin: origin,
                      onTap: _submitting
                          ? null
                          : () async {
                              await showServerDialog(context, ref);
                              if (mounted) _loadServerCapabilities();
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: SecuroTheme.of(context).foreground,
            ),
      );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.destructive.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.destructive.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 18, color: colors.destructive),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.destructive),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Row(
      children: [
        Expanded(child: Divider(color: colors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.mutedForeground),
          ),
        ),
        Expanded(child: Divider(color: colors.border)),
      ],
    );
  }
}

class _BiometricOptIn extends StatelessWidget {
  const _BiometricOptIn({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      borderRadius: BorderRadius.circular(SecuroRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged == null
                  ? null
                  : (v) => onChanged!(v ?? false),
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                'Stay signed in with biometrics',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.mutedForeground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerRow extends StatelessWidget {
  const _ServerRow({required this.origin, required this.onTap});
  final String origin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SecuroRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dns_outlined, size: 15, color: colors.mutedForeground),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                Uri.parse(origin).host,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.mutedForeground),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.edit_outlined, size: 13, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}
