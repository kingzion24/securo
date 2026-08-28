import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/color.dart';
import '../../core/format/currencies.dart';
import '../../core/icons/lucide_icon_map.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/pressable.dart';
import '../../models/workspace.dart';
import '../auth/auth_controller.dart';
import 'workspace_controller.dart';

class WorkspaceSettingsScreen extends ConsumerStatefulWidget {
  const WorkspaceSettingsScreen({super.key});

  @override
  ConsumerState<WorkspaceSettingsScreen> createState() => _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState extends ConsumerState<WorkspaceSettingsScreen> {
  Workspace? _workspace;
  Map<String, int>? _stats;
  List<WorkspaceMember>? _members;
  bool _loading = true;
  String? _error;

  late final _nameController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = ref.read(workspaceRepositoryProvider);
    try {
      final workspace = await repo.current();
      final results = await Future.wait([
        repo.stats(workspace.id),
        repo.members(workspace.id),
      ]);
      if (!mounted) return;
      setState(() {
        _workspace = workspace;
        _nameController.text = workspace.name;
        _stats = results[0] as Map<String, int>;
        _members = results[1] as List<WorkspaceMember>;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = '$error';
        _loading = false;
      });
    }
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || name == _workspace?.name) return;
    setState(() => _saving = true);
    try {
      final updated = await ref.read(workspaceRepositoryProvider).update(
            _workspace!.id,
            name: name,
          );
      if (!mounted) return;
      setState(() => _workspace = updated);
      ref.invalidate(currentWorkspaceProvider);
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _setCurrency(String currency) async {
    setState(() => _saving = true);
    try {
      final updated = await ref
          .read(workspaceRepositoryProvider)
          .update(_workspace!.id, defaultCurrency: currency);
      if (!mounted) return;
      setState(() => _workspace = updated);
      // The workspace currency affects display currency defaults; the user
      // object itself doesn't need a re-fetch since currency_display is a
      // separate per-user preference, but other screens read the workspace
      // provider, so it must be invalidated.
      ref.invalidate(currentWorkspaceProvider);
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _invite() async {
    final emailController = TextEditingController();
    String role = 'editor';
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Invite member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: role,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'owner', child: Text('Owner')),
                  DropdownMenuItem(value: 'editor', child: Text('Editor')),
                  DropdownMenuItem(value: 'viewer', child: Text('Viewer')),
                ],
                onChanged: (v) => setDialogState(() => role = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Invite'),
            ),
          ],
        ),
      ),
    );
    if (result != true || !mounted) return;
    final email = emailController.text.trim();
    if (email.isEmpty) return;
    try {
      await ref.read(workspaceRepositoryProvider).invite(
            _workspace!.id,
            email: email,
            role: role,
          );
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _changeRole(WorkspaceMember member) async {
    final picked = await showPickerSheet<String>(
      context,
      title: 'Role for ${member.email}',
      items: const ['owner', 'editor', 'viewer'],
      labelBuilder: (r) => r[0].toUpperCase() + r.substring(1),
      selected: member.role.name,
    );
    if (picked == null || !mounted) return;
    try {
      await ref
          .read(workspaceRepositoryProvider)
          .updateMemberRole(_workspace!.id, member.userId, picked);
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _removeMember(WorkspaceMember member) async {
    final confirmed = await confirmDelete(context, title: 'Remove ${member.email}?');
    if (!confirmed || !mounted) return;
    try {
      await ref.read(workspaceRepositoryProvider).removeMember(_workspace!.id, member.userId);
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _archive() async {
    final confirmed = await confirmDelete(
      context,
      title: 'Archive "${_workspace!.name}"?',
      message: 'You can switch to another workspace afterward. This is not permanent deletion.',
      confirmLabel: 'Archive',
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(workspaceRepositoryProvider).archive(_workspace!.id);
      if (!mounted) return;
      ref.invalidate(currentWorkspaceProvider);
      ref.invalidate(workspacesProvider);
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final user = ref.watch(authControllerProvider).user;
    bool isSelf(WorkspaceMember m) => m.email == user?.email;

    return LargeTitleScrollView(
      title: 'Workspace',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 60),
          sliver: SliverToBoxAdapter(
            child: _loading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _error != null
                    ? ErrorState(message: _error!, onRetry: _load)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          SecuroCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: (parseHexColor(_workspace!.color) ?? colors.chart1)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(SecuroRadius.md),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    lucideIcon(_workspace!.icon),
                                    color: parseHexColor(_workspace!.color) ?? colors.chart1,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_workspace!.name,
                                          style: Theme.of(context).textTheme.titleMedium),
                                      Text(
                                        _workspace!.role?.name ?? 'member',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: colors.mutedForeground),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _StatTile(label: 'Members', value: '${_stats?['members'] ?? 0}'),
                              const SizedBox(width: 10),
                              _StatTile(label: 'Accounts', value: '${_stats?['accounts'] ?? 0}'),
                              const SizedBox(width: 10),
                              _StatTile(
                                  label: 'Transactions',
                                  value: '${_stats?['transactions'] ?? 0}'),
                            ],
                          ),
                          const SizedBox(height: 24),

                          if (_workspace!.canManage) ...[
                            const SectionTitle('Details'),
                            SecuroCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name', style: Theme.of(context).textTheme.labelMedium),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _nameController,
                                    onSubmitted: (_) => _saveName(),
                                    decoration: InputDecoration(
                                      suffixIcon: _saving
                                          ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            )
                                          : IconButton(
                                              icon: const Icon(Icons.check, size: 20),
                                              onPressed: _saveName,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Default currency',
                                      style: Theme.of(context).textTheme.labelMedium),
                                  const SizedBox(height: 6),
                                  Pressable(
                                    onTap: () async {
                                      final picked = await showPickerSheet<String>(
                                        context,
                                        title: 'Default currency',
                                        items: kCurrencyOptions,
                                        labelBuilder: (c) => c,
                                        selected: _workspace!.defaultCurrency,
                                      );
                                      if (picked != null) _setCurrency(picked);
                                    },
                                    child: Container(
                                      height: 44,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(SecuroRadius.md),
                                        border: Border.all(color: colors.input),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(_workspace!.defaultCurrency)),
                                          Icon(Icons.unfold_more,
                                              size: 18, color: colors.mutedForeground),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          Row(
                            children: [
                              const Expanded(child: SectionTitle('Members')),
                              if (_workspace!.canManage)
                                IconButton(
                                  icon: const Icon(Icons.person_add_outlined, size: 20),
                                  onPressed: _invite,
                                ),
                            ],
                          ),
                          SecuroCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                for (var i = 0; i < _members!.length; i++) ...[
                                  if (i > 0) Divider(height: 1, color: colors.border),
                                  _MemberRow(
                                    member: _members![i],
                                    canManage: _workspace!.canManage && !isSelf(_members![i]),
                                    onChangeRole: () => _changeRole(_members![i]),
                                    onRemove: () => _removeMember(_members![i]),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          if (_workspace!.canManage) ...[
                            const SizedBox(height: 24),
                            const SectionTitle('Danger zone'),
                            SecuroCard(
                              child: Pressable(
                                onTap: _archive,
                                child: Row(
                                  children: [
                                    Icon(Icons.archive_outlined,
                                        size: 18, color: colors.destructive),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Archive this workspace',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: colors.destructive,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Expanded(
      child: SecuroCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(value,
                style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: colors.mutedForeground)),
          ],
        ),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.canManage,
    required this.onChangeRole,
    required this.onRemove,
  });
  final WorkspaceMember member;
  final bool canManage;
  final VoidCallback onChangeRole;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.displayName ?? member.email,
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(member.email,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: colors.mutedForeground)),
              ],
            ),
          ),
          if (canManage)
            Pressable(
              onTap: onChangeRole,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: BorderRadius.circular(SecuroRadius.pill),
                ),
                child: Text(member.role.name,
                    style: Theme.of(context).textTheme.labelSmall),
              ),
            )
          else
            Text(member.role.name,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: colors.mutedForeground)),
          if (canManage)
            IconButton(
              icon: Icon(Icons.close, size: 18, color: colors.mutedForeground),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
