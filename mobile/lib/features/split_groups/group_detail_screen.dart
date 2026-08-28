import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/format/money.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/pressable.dart';
import '../../models/group_member.dart';
import '../../models/split_group.dart';
import '../workspace/workspace_controller.dart';
import 'group_form_screen.dart';
import 'split_groups_screen.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  const GroupDetailScreen({required this.group, super.key});
  final SplitGroup group;

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  late SplitGroup _group = widget.group;
  List<GroupMember> _members = [];
  GroupBalances? _balances;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = ref.read(splitGroupsRepositoryProvider);
    try {
      final results = await Future.wait([
        repo.members(_group.id),
        repo.balances(_group.id),
      ]);
      if (!mounted) return;
      setState(() {
        _members = results[0] as List<GroupMember>;
        _balances = results[1] as GroupBalances;
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

  Future<void> _edit() async {
    final saved = await pushFormScreen<bool>(context, GroupFormScreen(group: _group));
    if (saved == true && mounted) {
      // The list-page repository doesn't expose a single-group getter; a
      // quick re-list-and-find keeps this screen's header accurate without
      // adding a `GET /groups/{id}` method for one field.
      final all = await ref.read(splitGroupsRepositoryProvider).list();
      final updated = all.where((g) => g.id == _group.id).firstOrNull;
      if (updated != null && mounted) setState(() => _group = updated);
    }
  }

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: 'Delete "${_group.name}"?',
      message: 'This removes the group and its split history.',
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(splitGroupsRepositoryProvider).delete(_group.id);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _addMember() async {
    final controller = TextEditingController();
    final name = await showAppDialog<String>(
      context,
      builder: (context) => AppDialog(
        title: 'Add member',
        content: TextField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.center,
        ),
        actions: [
          AppDialogAction(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppDialogAction(
            label: 'Add',
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || !mounted) return;
    try {
      await ref.read(splitGroupsRepositoryProvider).addMember(_group.id, name: name);
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _removeMember(GroupMember member) async {
    final confirmed = await confirmDelete(context, title: 'Remove ${member.name}?');
    if (!confirmed || !mounted) return;
    try {
      await ref.read(splitGroupsRepositoryProvider).removeMember(_group.id, member.id);
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return LargeTitleScrollView(
      title: _group.name,
      actions: !canEdit
          ? null
          : [
              PopupMenuButton<String>(
                onSelected: (v) => v == 'edit' ? _edit() : _delete(),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                else if (_error != null)
                  ErrorState(message: _error!, onRetry: _load)
                else ...[
                  if (_balances != null && _balances!.lines.isNotEmpty) ...[
                    const SectionTitle('Balances'),
                    SecuroCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (var i = 0; i < _balances!.lines.length; i++) ...[
                            if (i > 0) Divider(height: 1, color: colors.border),
                            _BalanceRow(
                              line: _balances!.lines[i],
                              members: _members,
                              currency: _balances!.defaultCurrency,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      const Expanded(child: SectionTitle('Members')),
                      if (canEdit)
                        IconButton(
                          icon: const Icon(Icons.person_add_outlined, size: 20),
                          onPressed: _addMember,
                        ),
                    ],
                  ),
                  if (_members.isEmpty)
                    const EmptyState(icon: Icons.people_outline, title: 'No members yet')
                  else
                    SecuroCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (var i = 0; i < _members.length; i++) ...[
                            if (i > 0) Divider(height: 1, color: colors.border),
                            _MemberRow(
                              member: _members[i],
                              canEdit: canEdit,
                              onRemove: () => _removeMember(_members[i]),
                            ),
                          ],
                        ],
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

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({required this.line, required this.members, required this.currency});
  final GroupBalanceLine line;
  final List<GroupMember> members;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final member = members.where((m) => m.id == line.memberId).firstOrNull;
    final owesYou = line.amountInDefaultCurrency > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(member?.name ?? 'Member', style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            formatMoney(line.amountInDefaultCurrency.abs(), currency: currency),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Text(
            owesYou ? 'owes you' : 'you owe',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.canEdit, required this.onRemove});
  final GroupMember member;
  final bool canEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Pressable(
      onLongPress: member.isSelf ? null : (canEdit ? onRemove : null),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(LucideIcons.user, size: 16, color: colors.mutedForeground),
            const SizedBox(width: 10),
            Expanded(child: Text(member.name, style: Theme.of(context).textTheme.bodyMedium)),
            if (member.isSelf)
              Text(
                'You',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: colors.mutedForeground),
              ),
          ],
        ),
      ),
    );
  }
}
