import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/payee.dart';
import 'payees_repository.dart';

final payeesRepositoryProvider = Provider<PayeesRepository>(
  (ref) => PayeesRepository(ref.watch(apiClientProvider)),
);

class PayeesScreen extends ConsumerWidget {
  const PayeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(payeesRepositoryProvider);
    return ResourceListScreen<Payee>(
      title: 'Payees',
      fetch: repository.list,
      emptyIcon: Icons.people_outline,
      emptyTitle: 'No payees yet',
      emptyMessage: 'People and businesses you pay or get paid by show up here.',
      itemBuilder: (context, payee) => _PayeeTile(payee: payee),
    );
  }
}

class _PayeeTile extends StatelessWidget {
  const _PayeeTile({required this.payee});
  final Payee payee;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final initial = payee.name.isNotEmpty ? payee.name[0].toUpperCase() : '?';

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
              child: Text(
                initial,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.mutedForeground,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                payee.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (payee.type != null)
              Text(
                payee.type == 'company' ? 'Company' : 'Person',
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
