import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/loan.dart';
import 'loans_repository.dart';

final loansRepositoryProvider = Provider<LoansRepository>(
  (ref) => LoansRepository(ref.watch(apiClientProvider)),
);

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(loansRepositoryProvider);
    final locale = ref.watch(displayLocaleProvider);

    return ResourceListScreen<Loan>(
      title: 'Loans',
      fetch: repository.list,
      emptyIcon: Icons.handshake_outlined,
      emptyTitle: 'No loans tracked',
      emptyMessage: 'Money you lent or borrowed shows up here.',
      itemBuilder: (context, loan) => _LoanTile(loan: loan, locale: locale),
    );
  }
}

class _LoanTile extends StatelessWidget {
  const _LoanTile({required this.loan, this.locale});

  final Loan loan;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

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
              // The icon direction plus the "Owes you" / "You owe" label
              // already say who owes whom; a red/green accent on top of that
              // would be decorative, not informative.
              child: Icon(
                loan.theyOweMe ? Icons.call_received : Icons.call_made,
                size: 18,
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loan.personName,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    loan.theyOweMe ? 'Owes you' : 'You owe',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
            Text(
              formatMoney(loan.remainingAmount, currency: loan.currency, locale: locale),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
