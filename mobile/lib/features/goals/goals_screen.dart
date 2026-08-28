import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bloc/resource_list_cubit.dart';
import '../../core/format/color.dart';
import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/icons/lucide_icon_map.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/goal.dart';
import '../workspace/workspace_controller.dart';
import 'goal_form_screen.dart';
import 'goals_repository.dart';

final goalsRepositoryProvider = Provider<GoalsRepository>(
  (ref) => GoalsRepository(ref.watch(apiClientProvider)),
);

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(goalsRepositoryProvider);
    final locale = ref.watch(displayLocaleProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<GoalSummary>(
      title: 'Goals',
      fetch: repository.list,
      emptyIcon: Icons.flag_outlined,
      emptyTitle: 'No goals yet',
      emptyMessage: 'Set a target to save toward and track progress here.',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New goal',
                  onPressed: () async {
                    final created =
                        await pushFormScreen<bool>(context, const GoalFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<GoalSummary>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, goal) =>
          _GoalTile(goal: goal, locale: locale, canEdit: canEdit, repository: repository),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.goal,
    required this.canEdit,
    required this.repository,
    this.locale,
  });

  final GoalSummary goal;
  final bool canEdit;
  final GoalsRepository repository;
  final String? locale;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved = await pushFormScreen<bool>(context, GoalFormScreen(goal: goal));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<GoalSummary>>().load();
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit) return;
    final confirmed = await confirmDelete(context, title: 'Delete "${goal.name}"?');
    if (!confirmed || !context.mounted) return;
    try {
      await repository.delete(goal.id);
      if (context.mounted) context.read<ResourceListCubit<GoalSummary>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final color = parseHexColor(goal.color) ?? colors.chart1;
    final progress = (goal.percentage / 100).clamp(0, 1).toDouble();

    return Pressable(
      onTap: () => _edit(context),
      onLongPress: () => _delete(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: colors.muted,
                    color: goal.isAchieved ? colors.chart3 : color,
                  ),
                  Icon(lucideIcon(goal.icon), size: 18, color: color),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatMoney(goal.currentAmount, currency: goal.currency, locale: locale)} of '
                    '${formatMoney(goal.targetAmount, currency: goal.currency, locale: locale)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
            Text(
              '${goal.percentage.round()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: goal.isAchieved ? colors.chart3 : colors.foreground,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
