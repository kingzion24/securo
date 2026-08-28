import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/recurring_transaction.dart';
import 'recurring_repository.dart';

final recurringRepositoryProvider = Provider<RecurringRepository>(
  (ref) => RecurringRepository(ref.watch(apiClientProvider)),
);

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(recurringRepositoryProvider);
    final locale = ref.watch(displayLocaleProvider);

    return ResourceListScreen<RecurringTransaction>(
      title: 'Recurring',
      fetch: repository.list,
      emptyIcon: Icons.repeat,
      emptyTitle: 'No recurring transactions',
      emptyMessage: 'Bills and subscriptions that repeat show up here.',
      itemBuilder: (context, item) => _RecurringTile(item: item, locale: locale),
    );
  }
}

class _RecurringTile extends StatelessWidget {
  const _RecurringTile({required this.item, this.locale});

  final RecurringTransaction item;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final amount = item.signedAmount;
    final next = DateTime.tryParse(item.nextOccurrence);

    return Pressable(
      onTap: () {},
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
              child: Icon(Icons.repeat, size: 18, color: colors.mutedForeground),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.description,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (!item.isActive) ...[
                        const SizedBox(width: 6),
                        Text(
                          'Paused',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: colors.mutedForeground),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      _frequencyLabel(item.frequency),
                      if (next != null) 'next ${DateFormat.MMMd(locale).format(next)}',
                    ].join(' · '),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
            Text(
              formatSignedMoney(amount, currency: item.currency, locale: locale),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _frequencyLabel(String frequency) => switch (frequency) {
        'weekly' => 'Weekly',
        'monthly' => 'Monthly',
        'quarterly' => 'Quarterly',
        'yearly' => 'Yearly',
        _ => frequency,
      };
}
