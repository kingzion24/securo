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
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/budget.dart';
import '../workspace/workspace_controller.dart';
import 'budget_form_screen.dart';
import 'budgets_repository.dart';

final budgetsRepositoryProvider = Provider<BudgetsRepository>(
  (ref) => BudgetsRepository(ref.watch(apiClientProvider)),
);

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(budgetsRepositoryProvider);
    final currency = ref.watch(displayCurrencyProvider);
    final locale = ref.watch(displayLocaleProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<BudgetVsActual>(
      title: 'Budgets',
      fetch: repository.comparisonForCurrentMonth,
      emptyIcon: Icons.savings_outlined,
      emptyTitle: 'No budgets set for this month',
      emptyMessage: 'Set a monthly amount per category to track spending against it.',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Set a budget',
                  onPressed: () async {
                    final created =
                        await pushFormScreen<bool>(context, const BudgetFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<BudgetVsActual>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, budget) => _BudgetTile(
        budget: budget,
        currency: currency,
        locale: locale,
        canEdit: canEdit,
        repository: repository,
      ),
    );
  }
}

class _BudgetTile extends StatelessWidget {
  const _BudgetTile({
    required this.budget,
    required this.currency,
    required this.canEdit,
    required this.repository,
    this.locale,
  });

  final BudgetVsActual budget;
  final String currency;
  final bool canEdit;
  final BudgetsRepository repository;
  final String? locale;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved = await pushFormScreen<bool>(context, BudgetFormScreen(budget: budget));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<BudgetVsActual>>().load();
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit || budget.budgetAmount == null) return;
    final confirmed =
        await confirmDelete(context, title: 'Remove budget for "${budget.categoryName}"?');
    if (!confirmed || !context.mounted) return;
    try {
      await repository.deleteForCategory(budget.categoryId);
      if (context.mounted) context.read<ResourceListCubit<BudgetVsActual>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final color = parseHexColor(budget.categoryColor) ?? colors.chart2;
    final overBudget = budget.isOverBudget;

    return Pressable(
      onTap: () => _edit(context),
      onLongPress: () => _delete(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(SecuroRadius.sm),
                  ),
                  alignment: Alignment.center,
                  child: Icon(lucideIcon(budget.categoryIcon), size: 15, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    budget.categoryName,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  budget.budgetAmount == null
                      ? formatMoney(budget.actualAmount, currency: currency, locale: locale)
                      : '${formatMoney(budget.actualAmount, currency: currency, locale: locale)} / '
                        '${formatMoney(budget.budgetAmount!, currency: currency, locale: locale)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: overBudget ? colors.destructive : colors.mutedForeground,
                      ),
                ),
              ],
            ),
            if (budget.budgetAmount != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: budget.progress.clamp(0, 1).toDouble(),
                  minHeight: 6,
                  backgroundColor: colors.muted,
                  color: overBudget ? colors.destructive : color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
