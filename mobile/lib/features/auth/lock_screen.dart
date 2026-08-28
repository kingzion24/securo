import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/theme.dart';
import 'auth_controller.dart';

/// Idle-timeout lock, matching the web app's lock screen (commit e95bba0).
///
/// The session is intact here — the token is still held. The user is proving
/// it is still them, so the way out is a device credential, not a fresh login.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _prompting = false;

  @override
  void initState() {
    super.initState();
    // Prompt straight away: the user just returned to the app, so making them
    // tap an "unlock" button first is a wasted step.
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (_prompting) return;
    setState(() => _prompting = true);

    final controller = ref.read(authControllerProvider.notifier);
    final ok = await controller.authenticateWithBiometrics(
      reason: 'Unlock Securo',
    );

    if (!mounted) return;
    setState(() => _prompting = false);
    if (ok) controller.unlock();
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg', width: 56, height: 56),
              const SizedBox(height: 24),
              Icon(Icons.lock_outline, size: 28, color: colors.mutedForeground),
              const SizedBox(height: 12),
              Text(
                'Locked',
                style: text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user == null
                    ? 'Unlock to continue.'
                    : 'Unlock to continue as ${user.label}.',
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(color: colors.mutedForeground),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _prompting ? null : _unlock,
                icon: const Icon(Icons.fingerprint, size: 20),
                label: const Text('Unlock'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _prompting
                    ? null
                    : () =>
                        ref.read(authControllerProvider.notifier).logout(),
                child: const Text('Sign out instead'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
