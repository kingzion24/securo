import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/currencies.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/pressable.dart';
import '../admin/admin_screen.dart';
import '../agents/agents_screen.dart';
import '../auth/auth_controller.dart';
import '../auth/server_dialog.dart';
import '../workspace/workspace_settings_screen.dart';

/// Currencies offered in the picker — the ISO codes `frontend/src/lib/format.ts`
/// treats as first-class, kept in the same order as the web app's selector.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _savingCurrency = false;
  List<Map<String, dynamic>>? _passkeys;
  bool _loadingPasskeys = true;
  String? _passkeyError;

  @override
  void initState() {
    super.initState();
    _loadPasskeys();
  }

  Future<void> _loadPasskeys() async {
    try {
      final list = await ref.read(passkeyRepositoryProvider).list();
      if (!mounted) return;
      setState(() {
        _passkeys = list;
        _loadingPasskeys = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _passkeyError = '$error';
        _loadingPasskeys = false;
      });
    }
  }

  Future<void> _addPasskey() async {
    try {
      await ref.read(passkeyRepositoryProvider).register();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Passkey added')));
      setState(() => _loadingPasskeys = true);
      await _loadPasskeys();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not add passkey: $error')));
    }
  }

  Future<void> _removePasskey(String id) async {
    try {
      await ref.read(passkeyRepositoryProvider).delete(id);
      if (!mounted) return;
      setState(() => _passkeys = _passkeys?.where((p) => p['id'] != id).toList());
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not remove passkey: $error')));
    }
  }

  Future<void> _setCurrency(String currency) async {
    final controller = ref.read(authControllerProvider.notifier);
    final user = ref.read(authControllerProvider).user;
    if (user == null) return;
    setState(() => _savingCurrency = true);
    try {
      await ref.read(authRepositoryProvider).updatePreferences(
            user.preferences.copyWith(currencyDisplay: currency),
          );
      await controller.refreshUser();
    } finally {
      if (mounted) setState(() => _savingCurrency = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final auth = ref.watch(authControllerProvider);
    final user = auth.user;
    final origin = ref.watch(baseUrlProvider);
    final currentCurrency = user?.preferences.currencyDisplay ?? 'USD';
    // The server accepts a much longer, deployment-configured currency list
    // than this picker's common-case shortlist; if the account's current
    // currency isn't on it, it still has to appear so the dropdown has a
    // valid selected value instead of throwing.
    final currencyChoices = kCurrencyOptions.contains(currentCurrency)
        ? kCurrencyOptions
        : [currentCurrency, ...kCurrencyOptions];

    return LargeTitleScrollView(
      title: 'Settings',
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            MediaQuery.of(context).padding.bottom + 40,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Profile'),
          SecuroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.label ?? '', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colors.mutedForeground),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: SectionTitle('Display currency')),
              if (_savingCurrency)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          SecuroCard(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 44,
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: currentCurrency,
                    items: [
                      for (final code in currencyChoices)
                        DropdownMenuItem(value: code, child: Text(code)),
                    ],
                    onChanged: _savingCurrency
                        ? null
                        : (value) {
                            if (value != null) _setCurrency(value);
                          },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: SectionTitle('Passkeys')),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add a passkey',
                onPressed: _addPasskey,
              ),
            ],
          ),
          if (_loadingPasskeys)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_passkeyError != null)
            ErrorState(message: _passkeyError!, onRetry: _loadPasskeys)
          else if (_passkeys!.isEmpty)
            const EmptyState(
              icon: Icons.fingerprint,
              title: 'No passkeys yet',
              message: 'Add one to sign in without a password.',
            )
          else
            SecuroCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < _passkeys!.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: colors.border),
                    _PasskeyTile(
                      passkey: _passkeys![i],
                      onDelete: () => _removePasskey(_passkeys![i]['id'] as String),
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 24),
          const SectionTitle('Workspace'),
          SecuroCard(
            child: Pressable(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const WorkspaceSettingsScreen()),
              ),
              child: Row(
                children: [
                  Icon(Icons.business_outlined, size: 18, color: colors.mutedForeground),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('Workspace settings')),
                  Icon(Icons.chevron_right, color: colors.mutedForeground),
                ],
              ),
            ),
          ),
          if (auth.isAgentsEnabled) ...[
            const SizedBox(height: 24),
            const SectionTitle('Agents'),
            SecuroCard(
              child: Pressable(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const AgentsScreen()),
                ),
                child: Row(
                  children: [
                    Icon(Icons.smart_toy_outlined, size: 18, color: colors.mutedForeground),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('AI agents')),
                    Icon(Icons.chevron_right, color: colors.mutedForeground),
                  ],
                ),
              ),
            ),
          ],
          if (user?.isSuperuser == true) ...[
            const SizedBox(height: 24),
            const SectionTitle('Admin'),
            SecuroCard(
              child: Pressable(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const AdminScreen()),
                ),
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings_outlined,
                        size: 18, color: colors.mutedForeground),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('Admin settings')),
                    Icon(Icons.chevron_right, color: colors.mutedForeground),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const SectionTitle('Server'),
          SecuroCard(
            child: Pressable(
              onTap: () => showServerDialog(context, ref),
              child: Row(
                children: [
                  Icon(Icons.dns_outlined, size: 18, color: colors.mutedForeground),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      Uri.parse(origin).host,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colors.mutedForeground),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SecuroCard(
            child: Pressable(
              onTap: () => ref.read(authControllerProvider.notifier).logout(),
              child: Row(
                children: [
                  Icon(Icons.logout, size: 18, color: colors.destructive),
                  const SizedBox(width: 10),
                  Text(
                    'Sign out',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colors.destructive, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PasskeyTile extends StatelessWidget {
  const _PasskeyTile({required this.passkey, required this.onDelete});
  final Map<String, dynamic> passkey;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.fingerprint, size: 18, color: colors.mutedForeground),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              passkey['name'] as String? ?? 'Passkey',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: colors.mutedForeground),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
