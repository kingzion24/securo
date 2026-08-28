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
import '../../models/payee.dart';
import '../workspace/workspace_controller.dart';
import 'payee_form_screen.dart';
import 'payees_repository.dart';

final payeesRepositoryProvider = Provider<PayeesRepository>(
  (ref) => PayeesRepository(ref.watch(apiClientProvider)),
);

class PayeesScreen extends ConsumerWidget {
  const PayeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(payeesRepositoryProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<Payee>(
      title: 'Payees',
      fetch: repository.list,
      emptyIcon: Icons.people_outline,
      emptyMessage: 'People and businesses you pay or get paid by show up here.',
      emptyTitle: 'No payees yet',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New payee',
                  onPressed: () async {
                    final created =
                        await pushFormScreen<bool>(context, const PayeeFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<Payee>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, payee) =>
          _PayeeTile(payee: payee, canEdit: canEdit, repository: repository),
    );
  }
}

class _PayeeTile extends StatelessWidget {
  const _PayeeTile({required this.payee, required this.canEdit, required this.repository});
  final Payee payee;
  final bool canEdit;
  final PayeesRepository repository;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved = await pushFormScreen<bool>(context, PayeeFormScreen(payee: payee));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<Payee>>().load();
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit) return;
    final confirmed = await confirmDelete(context, title: 'Delete "${payee.name}"?');
    if (!confirmed || !context.mounted) return;
    try {
      await repository.delete(payee.id);
      if (context.mounted) context.read<ResourceListCubit<Payee>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final initial = payee.name.isNotEmpty ? payee.name[0].toUpperCase() : '?';

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
            if (canEdit) ...[
              const SizedBox(width: 6),
              Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
            ],
          ],
        ),
      ),
    );
  }
}
