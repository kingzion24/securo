import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/responsive.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/pressable.dart';
import '../../models/account.dart';
import '../../models/transaction.dart';
import '../transactions/transactions_repository.dart';
import '../transactions/transactions_screen.dart' show transactionsRepositoryProvider;
import '../workspace/workspace_controller.dart';
import 'account_form_screen.dart';
import 'account_type.dart';
import 'accounts_screen.dart';

class AccountDetailScreen extends ConsumerStatefulWidget {
  const AccountDetailScreen({required this.account, super.key});
  final Account account;

  @override
  ConsumerState<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends ConsumerState<AccountDetailScreen> {
  late Account _account = widget.account;
  TransactionsPage? _page;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final page = await ref
          .read(transactionsRepositoryProvider)
          .list(accountId: _account.id, limit: 30);
      if (!mounted) return;
      setState(() {
        _page = page;
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
    final saved = await pushFormScreen<bool>(context, AccountFormScreen(account: _account));
    if (saved == true && mounted) {
      final refreshed = await ref.read(accountsRepositoryProvider).get(_account.id);
      if (mounted) setState(() => _account = refreshed);
    }
  }

  Future<void> _toggleClosed() async {
    final repo = ref.read(accountsRepositoryProvider);
    try {
      final updated =
          _account.isClosed ? await repo.reopen(_account.id) : await repo.close(_account.id);
      if (mounted) setState(() => _account = updated);
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: 'Delete "${_account.label}"?',
      message: 'This removes the account and its transactions. This cannot be undone.',
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(accountsRepositoryProvider).delete(_account.id);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final style = accountTypeStyle(_account.type);
    final locale = ref.watch(displayLocaleProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return LargeTitleScrollView(
      title: _account.label,
      actions: !canEdit
          ? null
          : [
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _edit();
                    case 'close':
                      _toggleClosed();
                    case 'delete':
                      _delete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                    value: 'close',
                    child: Text(_account.isClosed ? 'Reopen' : 'Close'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            context.responsive.pagePadding,
            12,
            context.responsive.pagePadding,
            8,
          ),
          sliver: SliverToBoxAdapter(
            child: SecuroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: style.background,
                          borderRadius: BorderRadius.circular(SecuroRadius.md),
                        ),
                        alignment: Alignment.center,
                        child: Icon(style.icon, size: 20, color: style.foreground),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(style.label, style: Theme.of(context).textTheme.bodySmall),
                            if (_account.isClosed)
                              Text(
                                'Closed',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: colors.mutedForeground),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formatMoney(_account.currentBalance,
                          currency: _account.currency, locale: locale),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            context.responsive.pagePadding,
            8,
            context.responsive.pagePadding,
            100,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Recent transactions'),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                else if (_error != null)
                  ErrorState(message: _error!, onRetry: _load)
                else if (_page!.items.isEmpty)
                  const EmptyState(
                    icon: Icons.swap_horiz,
                    title: 'No transactions on this account yet',
                  )
                else
                  SecuroCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < _page!.items.length; i++) ...[
                          if (i > 0) Divider(height: 1, color: colors.border),
                          _TxRow(transaction: _page!.items[i], locale: locale),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TxRow extends StatelessWidget {
  const _TxRow({required this.transaction, this.locale});
  final Transaction transaction;
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
            Expanded(
              child: Text(
                transaction.description.isNotEmpty ? transaction.description : 'Transaction',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              formatSignedMoney(
                transaction.displayAmount,
                currency: transaction.currency,
                locale: locale,
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600, color: colors.foreground),
            ),
          ],
        ),
      ),
    );
  }
}
