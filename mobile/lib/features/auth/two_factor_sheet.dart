import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_exception.dart';
import '../../core/theme/theme.dart';
import 'auth_controller.dart';

/// Second-factor prompt, shown when `/auth/login` answers with a challenge
/// instead of a token.
Future<void> showTwoFactorSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => const _TwoFactorSheet(),
    );

class _TwoFactorSheet extends ConsumerStatefulWidget {
  const _TwoFactorSheet();

  @override
  ConsumerState<_TwoFactorSheet> createState() => _TwoFactorSheetState();
}

class _TwoFactorSheetState extends ConsumerState<_TwoFactorSheet> {
  final _code = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _code.text.trim();
    if (code.length < 6) {
      setState(() => _error = 'Enter the 6-digit code');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await ref.read(authControllerProvider.notifier).verifyTotp(code);
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message;
          _submitting = false;
        });
        _code.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Two-factor authentication',
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter the 6-digit code from your authenticator app.',
            style: text.bodyMedium?.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _code,
            autofocus: true,
            enabled: !_submitting,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: text.headlineSmall?.copyWith(
              letterSpacing: 10,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '000000',
              errorText: _error,
            ),
            onChanged: (value) {
              if (value.length == 6 && !_submitting) _verify();
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submitting ? null : _verify,
            child: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Verify'),
          ),
          TextButton(
            onPressed: _submitting
                ? null
                : () {
                    ref.read(authControllerProvider.notifier).cancel2fa();
                    Navigator.of(context).pop();
                  },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
