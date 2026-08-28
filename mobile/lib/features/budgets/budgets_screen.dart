import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/color.dart';
import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/icons/lucide_icon_map.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/budget.dart';
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

    return ResourceListScreen<BudgetVsActual>(
      title: 'Budgets',
      fetch: repository.comparisonForCurrentMonth,
      emptyIcon: Icons.savings_outlined,
      emptyTitle: 'No budgets set for this month',
      emptyMessage: 'Set a monthly amount per category to track spending against it.',
      itemBuilder: (context, budget) =>
          _BudgetTile(budget: budget, currency: currency, locale: locale),
    );
  }
}

class _BudgetTile extends StatelessWidget {
  const _BudgetTile({required this.budget, required this.currency, this.locale});

  final BudgetVsActual budget;
  final String currency;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final color = parseHexColor(budget.categoryColor) ?? colors.chart2;
    final overBudget = budget.isOverBudget;

    return Pressable(
      onTap: () {},
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
