import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import 'auth_controller.dart';

/// Lets the user point the app at a different Securo deployment.
///
/// The default is baked in, so most people never open this — it exists so one
/// build can serve a second server without a rebuild.
Future<void> showServerDialog(BuildContext context, WidgetRef ref) async {
  final controller = TextEditingController(text: ref.read(baseUrlProvider));
  final formKey = GlobalKey<FormState>();

  final origin = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Server address'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'The address you open Securo at in a browser, without a trailing '
              'path.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'https://securo.example.ts.net',
              ),
              validator: _validate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            Navigator.of(context).pop(controller.text.trim());
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );

  controller.dispose();
  if (origin == null) return;
  await ref.read(authControllerProvider.notifier).setServerOrigin(origin);
}

String? _validate(String? value) {
  final raw = value?.trim() ?? '';
  if (raw.isEmpty) return 'Enter a server address';

  final uri = Uri.tryParse(raw);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    return 'Include the scheme, e.g. https://securo.example.ts.net';
  }
  if (uri.scheme != 'https' && uri.scheme != 'http') {
    return 'The address must start with http:// or https://';
  }
  // Passkeys and OIDC both require a secure origin on the backend side, so a
  // plain-http server silently loses those buttons. Worth saying up front.
  if (uri.scheme == 'http' && uri.host != 'localhost') {
    return 'Use https:// — passkeys and OIDC will not work over plain http';
  }
  return null;
}
