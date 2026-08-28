import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bloc/resource_list_cubit.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/rule.dart';
import '../workspace/workspace_controller.dart';
import 'rule_form_screen.dart';
import 'rules_repository.dart';

final rulesRepositoryProvider = Provider<RulesRepository>(
  (ref) => RulesRepository(ref.watch(apiClientProvider)),
);

class RulesScreen extends ConsumerWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(rulesRepositoryProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<Rule>(
      title: 'Rules',
      fetch: repository.list,
      emptyIcon: Icons.tune,
      emptyTitle: 'No rules yet',
      emptyMessage: 'Auto-categorize transactions as they come in.',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New rule',
                  onPressed: () async {
                    final created =
                        await pushFormScreen<bool>(context, const RuleFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<Rule>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, rule) =>
          _RuleTile(rule: rule, canEdit: canEdit, repository: repository),
    );
  }
}

class _RuleTile extends StatelessWidget {
  const _RuleTile({required this.rule, required this.canEdit, required this.repository});
  final Rule rule;
  final bool canEdit;
  final RulesRepository repository;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved = await pushFormScreen<bool>(context, RuleFormScreen(rule: rule));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<Rule>>().load();
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit) return;
    final confirmed = await confirmDelete(context, title: 'Delete "${rule.name}"?');
    if (!confirmed || !context.mounted) return;
    try {
      await repository.delete(rule.id);
      if (context.mounted) context.read<ResourceListCubit<Rule>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _toggleActive(BuildContext context, bool value) async {
    if (!canEdit) return;
    try {
      await repository.update(rule.id, isActive: value);
      if (context.mounted) context.read<ResourceListCubit<Rule>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return Pressable(
      onTap: () => _edit(context),
      onLongPress: () => _delete(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(SecuroRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.tune, size: 18, color: colors.mutedForeground),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${rule.conditions.length} '
                    '${rule.conditions.length == 1 ? 'condition' : 'conditions'} · '
                    '${rule.actions.length} ${rule.actions.length == 1 ? 'action' : 'actions'}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
            Switch(
              value: rule.isActive,
              onChanged: canEdit ? (v) => _toggleActive(context, v) : null,
            ),
          ],
        ),
      ),
    );
  }
}
