import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/bloc/resource_list_cubit.dart';
import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/loan.dart';
import '../workspace/workspace_controller.dart';
import 'loan_form_screen.dart';
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
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<Loan>(
      title: 'Loans',
      fetch: repository.list,
      emptyIcon: Icons.handshake_outlined,
      emptyTitle: 'No loans tracked',
      emptyMessage: 'Money you lent or borrowed shows up here.',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New loan',
                  onPressed: () async {
                    final created =
                        await pushFormScreen<bool>(context, const LoanFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<Loan>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, loan) =>
          _LoanTile(loan: loan, locale: locale, canEdit: canEdit, repository: repository),
    );
  }
}

class _LoanTile extends StatelessWidget {
  const _LoanTile({
    required this.loan,
    required this.canEdit,
    required this.repository,
    this.locale,
  });

  final Loan loan;
  final bool canEdit;
  final LoansRepository repository;
  final String? locale;

  Future<void> _openActions(BuildContext context) async {
    if (!canEdit) return;
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(loan.personName),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('repay'),
            child: const Text('Add repayment'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('edit'),
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop('delete'),
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
    if (!context.mounted || action == null) return;

    switch (action) {
      case 'repay':
        await _addRepayment(context);
      case 'edit':
        final saved = await pushFormScreen<bool>(context, LoanFormScreen(loan: loan));
        if (saved == true && context.mounted) {
          context.read<ResourceListCubit<Loan>>().load();
        }
      case 'delete':
        final confirmed = await confirmDelete(context, title: 'Delete "${loan.personName}"?');
        if (confirmed && context.mounted) {
          try {
            await repository.delete(loan.id);
            if (context.mounted) context.read<ResourceListCubit<Loan>>().load();
          } catch (error) {
            if (context.mounted) showAppToast(context, '$error', isError: true);
          }
        }
    }
  }

  Future<void> _addRepayment(BuildContext context) async {
    final controller = TextEditingController();
    final amount = await showAppDialog<double>(
      context,
      builder: (context) => AppDialog(
        title: 'Add repayment',
        content: TextField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: 'Amount'),
        ),
        actions: [
          AppDialogAction(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppDialogAction(
            label: 'Add',
            isDefaultAction: true,
            onPressed: () =>
                Navigator.of(context).pop(double.tryParse(controller.text.trim())),
          ),
        ],
      ),
    );
    if (amount == null || amount <= 0 || !context.mounted) return;
    try {
      await repository.addRepayment(
        loan.id,
        amount: amount,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      if (context.mounted) context.read<ResourceListCubit<Loan>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return Pressable(
      onTap: () => _openActions(context),
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
