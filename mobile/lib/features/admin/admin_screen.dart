import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/pressable.dart';
import '../../models/admin_user.dart';
import '../auth/auth_controller.dart';
import 'admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => AdminRepository(ref.watch(apiClientProvider)),
);

enum _AdminSection { users, appSettings }

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  _AdminSection _section = _AdminSection.users;

  @override
  Widget build(BuildContext context) {
    return LargeTitleScrollView(
      title: 'Admin',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoSlidingSegmentedControl<_AdminSection>(
                  groupValue: _section,
                  children: const {
                    _AdminSection.users: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text('Users'),
                    ),
                    _AdminSection.appSettings: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text('App Settings'),
                    ),
                  },
                  onValueChanged: (v) => setState(() => _section = v!),
                ),
                const SizedBox(height: 20),
                switch (_section) {
                  _AdminSection.users => const _UsersSection(),
                  _AdminSection.appSettings => const _AppSettingsSection(),
                },
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UsersSection extends ConsumerStatefulWidget {
  const _UsersSection();

  @override
  ConsumerState<_UsersSection> createState() => _UsersSectionState();
}

class _UsersSectionState extends ConsumerState<_UsersSection> {
  List<AdminUser>? _users;
  String? _error;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final users =
          await ref.read(adminRepositoryProvider).listUsers(search: _searchController.text);
      if (mounted) setState(() => _users = users);
    } catch (error) {
      if (mounted) setState(() => _error = '$error');
    }
  }

  Future<void> _createUser() async {
    final result = await showDialog<_UserFormResult>(
      context: context,
      builder: (context) => const _UserFormDialog(),
    );
    if (result == null || !mounted) return;
    try {
      await ref.read(adminRepositoryProvider).createUser(
            email: result.email,
            password: result.password!,
            isSuperuser: result.isSuperuser,
          );
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _editUser(AdminUser user) async {
    final currentUserId = ref.read(authControllerProvider).user?.id;
    final isSelf = user.id == currentUserId;
    final result = await showDialog<_UserFormResult>(
      context: context,
      builder: (context) => _UserFormDialog(user: user, disableToggles: isSelf),
    );
    if (result == null || !mounted) return;
    try {
      await ref.read(adminRepositoryProvider).updateUser(
            user.id,
            email: result.email,
            password: result.password,
            isActive: isSelf ? null : result.isActive,
            isSuperuser: isSelf ? null : result.isSuperuser,
          );
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _deleteUser(AdminUser user) async {
    final confirmed = await confirmDelete(context, title: 'Delete ${user.email}?');
    if (!confirmed || !mounted) return;
    try {
      await ref.read(adminRepositoryProvider).deleteUser(user.id);
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search users',
                backgroundColor: colors.muted,
                onChanged: (_) => _load(),
              ),
            ),
            IconButton(icon: const Icon(Icons.person_add_outlined), onPressed: _createUser),
          ],
        ),
        const SizedBox(height: 10),
        if (_error != null)
          ErrorState(message: _error!, onRetry: _load)
        else if (_users == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_users!.isEmpty)
          const EmptyState(icon: Icons.people_outline, title: 'No users found')
        else
          SecuroCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < _users!.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: colors.border),
                  Pressable(
                    onTap: () => _editUser(_users![i]),
                    onLongPress: () => _deleteUser(_users![i]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_users![i].email,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          if (_users![i].isSuperuser)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text('Admin',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: colors.mutedForeground)),
                            ),
                          if (!_users![i].isActive)
                            Text('Disabled',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: colors.destructive)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _UserFormResult {
  _UserFormResult({
    required this.email,
    this.password,
    this.isActive = true,
    this.isSuperuser = false,
  });
  final String email;
  final String? password;
  final bool isActive;
  final bool isSuperuser;
}

class _UserFormDialog extends StatefulWidget {
  const _UserFormDialog({this.user, this.disableToggles = false});
  final AdminUser? user;
  final bool disableToggles;

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  late final _email = TextEditingController(text: widget.user?.email ?? '');
  final _password = TextEditingController();
  late bool _isActive = widget.user?.isActive ?? true;
  late bool _isSuperuser = widget.user?.isSuperuser ?? false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? 'New user' : 'Edit user'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _email,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: widget.user == null ? 'Password' : 'New password (optional)',
              ),
            ),
            if (widget.user != null) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                value: _isActive,
                onChanged: widget.disableToggles
                    ? null
                    : (v) => setState(() => _isActive = v),
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Admin'),
              value: _isSuperuser,
              onChanged: widget.disableToggles
                  ? null
                  : (v) => setState(() => _isSuperuser = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final email = _email.text.trim();
            if (email.isEmpty) return;
            Navigator.of(context).pop(
              _UserFormResult(
                email: email,
                password: _password.text.trim().isEmpty ? null : _password.text.trim(),
                isActive: _isActive,
                isSuperuser: _isSuperuser,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _AppSettingsSection extends ConsumerStatefulWidget {
  const _AppSettingsSection();

  @override
  ConsumerState<_AppSettingsSection> createState() => _AppSettingsSectionState();
}

class _AppSettingsSectionState extends ConsumerState<_AppSettingsSection> {
  bool? _registrationEnabled;
  bool? _useProviderCategories;
  String _accountingMode = 'cash';
  String _numberFormat = 'auto';
  String _dateFormat = 'auto';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(adminRepositoryProvider);
    final results = await Future.wait([
      repo.getSetting('registration_enabled'),
      repo.getSetting('use_provider_categories'),
      repo.getSetting('credit_card_accounting_mode'),
      repo.getSetting('number_format'),
      repo.getSetting('date_format'),
    ]);
    if (!mounted) return;
    setState(() {
      _registrationEnabled = (results[0] ?? 'true') == 'true';
      _useProviderCategories = (results[1] ?? 'true') == 'true';
      _accountingMode = results[2] ?? 'cash';
      _numberFormat = results[3] ?? 'auto';
      _dateFormat = results[4] ?? 'auto';
      _loading = false;
    });
  }

  Future<void> _set(String key, String value) async {
    try {
      await ref.read(adminRepositoryProvider).setSetting(key, value);
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SecuroCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('New registrations allowed'),
            value: _registrationEnabled!,
            onChanged: (v) {
              setState(() => _registrationEnabled = v);
              _set('registration_enabled', v.toString());
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Use bank category suggestions'),
            subtitle: const Text('Off: only the rule engine categorizes synced transactions'),
            value: _useProviderCategories!,
            onChanged: (v) {
              setState(() => _useProviderCategories = v);
              _set('use_provider_categories', v.toString());
            },
          ),
          const Divider(height: 1),
          _PickerTile(
            title: 'Credit card accounting',
            value: _accountingMode,
            options: const {'cash': 'Cash (statement date)', 'accrual': 'Accrual (purchase date)'},
            onChanged: (v) {
              setState(() => _accountingMode = v);
              _set('credit_card_accounting_mode', v);
            },
          ),
          const Divider(height: 1),
          _PickerTile(
            title: 'Number format',
            value: _numberFormat,
            options: const {
              'auto': 'Auto (browser locale)',
              'comma_dot': '1,234.56',
              'dot_comma': '1.234,56',
              'space_comma': '1 234,56',
            },
            onChanged: (v) {
              setState(() => _numberFormat = v);
              _set('number_format', v);
            },
          ),
          const Divider(height: 1),
          _PickerTile(
            title: 'Date format',
            value: _dateFormat,
            options: const {
              'auto': 'Auto (browser locale)',
              'dmy': 'Day/Month/Year',
              'mdy': 'Month/Day/Year',
              'ymd': 'Year-Month-Day',
            },
            onChanged: (v) {
              setState(() => _dateFormat = v);
              _set('date_format', v);
            },
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });
  final String title;
  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return ListTile(
      title: Text(title),
      subtitle: Text(options[value] ?? value,
          style: TextStyle(color: colors.mutedForeground)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final picked = await showPickerSheet<String>(
          context,
          title: title,
          items: options.keys.toList(),
          labelBuilder: (k) => options[k]!,
          selected: value,
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}
