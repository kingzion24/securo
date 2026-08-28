import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/currencies.dart';
import '../../core/providers.dart';
import '../../core/responsive.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
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
      showAppToast(context, 'Passkey added');
      setState(() => _loadingPasskeys = true);
      await _loadPasskeys();
    } catch (error) {
      if (!mounted) return;
      showAppToast(context, 'Could not add passkey: $error', isError: true);
    }
  }

  Future<void> _removePasskey(String id) async {
    try {
      await ref.read(passkeyRepositoryProvider).delete(id);
      if (!mounted) return;
      setState(() => _passkeys = _passkeys?.where((p) => p['id'] != id).toList());
    } catch (error) {
      if (!mounted) return;
      showAppToast(context, 'Could not remove passkey: $error', isError: true);
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

  Future<void> _pickCurrency(List<String> choices, String current) async {
    final picked = await showPickerSheet<String>(
      context,
      title: 'Display currency',
      items: choices,
      labelBuilder: (c) => c,
      selected: current,
    );
    if (picked != null && picked != current) _setCurrency(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final responsive = context.responsive;
    final auth = ref.watch(authControllerProvider);
    final user = auth.user;
    final origin = ref.watch(baseUrlProvider);
    final themeMode = ref.watch(themeModeProvider);
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
            responsive.pagePadding,
            8,
            responsive.pagePadding,
            MediaQuery.of(context).padding.bottom + 40,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GroupedSection(
                  title: 'Profile',
                  rows: [
                    GroupedRow(
                      label: user?.label ?? '',
                      subtitle: user?.email,
                    ),
                  ],
                ),
                SizedBox(height: responsive.sectionGap),
                GroupedSection(
                  title: 'Appearance',
                  rows: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Text('System'),
                            icon: Icon(Icons.smartphone_outlined, size: 16),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Text('Light'),
                            icon: Icon(Icons.light_mode_outlined, size: 16),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                            icon: Icon(Icons.dark_mode_outlined, size: 16),
                          ),
                        ],
                        selected: {themeMode},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) =>
                            ref.read(themeModeProvider.notifier).setMode(s.first),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.sectionGap),
                GroupedSection(
                  title: 'Display currency',
                  rows: [
                    GroupedRow(
                      label: currentCurrency,
                      trailing: _savingCurrency
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.unfold_more, size: 18, color: colors.mutedForeground),
                      onTap: _savingCurrency
                          ? null
                          : () => _pickCurrency(currencyChoices, currentCurrency),
                    ),
                  ],
                ),
                SizedBox(height: responsive.sectionGap),
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
                  GroupedPanel(
                    children: [
                      for (final passkey in _passkeys!)
                        GroupedRow(
                          leadingIcon: Icons.fingerprint,
                          label: passkey['name'] as String? ?? 'Passkey',
                          trailing: IconButton(
                            icon: Icon(Icons.close, size: 18, color: colors.mutedForeground),
                            onPressed: () => _removePasskey(passkey['id'] as String),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                    ],
                  ),
                SizedBox(height: responsive.sectionGap),
                GroupedSection(
                  title: 'Workspace',
                  rows: [
                    GroupedRow(
                      leadingIcon: Icons.business_outlined,
                      label: 'Workspace settings',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const WorkspaceSettingsScreen()),
                      ),
                    ),
                    if (auth.isAgentsEnabled)
                      GroupedRow(
                        leadingIcon: Icons.smart_toy_outlined,
                        label: 'AI agents',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const AgentsScreen()),
                        ),
                      ),
                    if (user?.isSuperuser == true)
                      GroupedRow(
                        leadingIcon: Icons.admin_panel_settings_outlined,
                        label: 'Admin settings',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const AdminScreen()),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: responsive.sectionGap),
                GroupedSection(
                  title: 'Server',
                  rows: [
                    GroupedRow(
                      leadingIcon: Icons.dns_outlined,
                      label: Uri.parse(origin).host,
                      onTap: () => showServerDialog(context, ref),
                    ),
                  ],
                ),
                SizedBox(height: responsive.sectionGap),
                GroupedPanel(
                  children: [
                    GroupedRow(
                      leadingIcon: Icons.logout,
                      iconColor: colors.destructive,
                      label: 'Sign out',
                      destructive: true,
                      onTap: () => ref.read(authControllerProvider.notifier).logout(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
