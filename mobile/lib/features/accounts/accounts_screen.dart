import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/account.dart';
import '../workspace/workspace_controller.dart';
import 'account_detail_screen.dart';
import 'account_form_screen.dart';
import 'account_type.dart';
import 'accounts_repository.dart';
import 'bloc/accounts_bloc.dart';

final accountsRepositoryProvider = Provider<AccountsRepository>(
  (ref) => AccountsRepository(ref.watch(apiClientProvider)),
);

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(accountsRepositoryProvider);
    return BlocProvider(
      create: (_) => AccountsBloc(repository)..add(const AccountsRequested()),
      child: const _AccountsView(),
    );
  }
}

class _AccountsView extends ConsumerWidget {
  const _AccountsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(currentWorkspaceProvider).valueOrNull?.locale;
    final displayCurrency = ref.watch(displayCurrencyProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;
    final bloc = context.watch<AccountsBloc>();
    final state = bloc.state;

    return LargeTitleScrollView(
      title: 'Accounts',
      onRefresh: () async {
        context.read<AccountsBloc>().add(const AccountsRefreshed());
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      actions: [
        IconButton(
          icon: Icon(
            state.includeClosed
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          tooltip: state.includeClosed
              ? 'Hide closed accounts'
              : 'Show closed accounts',
          onPressed: () =>
              context.read<AccountsBloc>().add(const ClosedAccountsToggled()),
        ),
        if (canEdit)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New account',
              onPressed: () async {
                final created =
                    await pushFormScreen<bool>(context, const AccountFormScreen());
                if (created == true && context.mounted) {
                  context.read<AccountsBloc>().add(const AccountsRequested());
                }
              },
            ),
          ),
      ],
      slivers: switch (state.status) {
        AccountsStatus.initial ||
        AccountsStatus.loading =>
          const [_AccountsSkeleton()],
        AccountsStatus.failure => [
            SliverFillRemaining(
              hasScrollBody: false,
              child: ErrorState(
                message: state.error ?? 'Could not load accounts',
                onRetry: () =>
                    context.read<AccountsBloc>().add(const AccountsRequested()),
              ),
            ),
          ],
        AccountsStatus.success ||
        AccountsStatus.refreshing =>
          _accountsSlivers(
            state: state,
            locale: locale,
            displayCurrency: displayCurrency,
            canEdit: canEdit,
          ),
      },
    );
  }
}

List<Widget> _accountsSlivers({
  required AccountsState state,
  required String displayCurrency,
  required bool canEdit,
  String? locale,
}) {
  if (state.accounts.isEmpty) {
    return const [
      SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(
          icon: Icons.account_balance_outlined,
          title: 'No accounts yet',
          message: 'Accounts you add or connect show up here.',
        ),
      ),
    ];
  }

  final grouped = state.groupedByType;
  return [
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      sliver: SliverToBoxAdapter(
        child: Builder(
          builder: (context) {
            final colors = SecuroTheme.of(context);
            return Column(
              children: [
                for (final entry in grouped.entries) ...[
                  _TypeHeader(
                    type: entry.key,
                    total: state.totalByType(entry.key),
                    currency: displayCurrency,
                    locale: locale,
                  ),
                  const SizedBox(height: 8),
                  SecuroCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < entry.value.length; i++) ...[
                          if (i > 0) Divider(height: 1, color: colors.border),
                          _AccountTile(
                            account: entry.value[i],
                            displayCurrency: displayCurrency,
                            locale: locale,
                            canEdit: canEdit,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            );
          },
        ),
      ),
    ),
  ];
}

class _TypeHeader extends StatelessWidget {
  const _TypeHeader({
    required this.type,
    required this.total,
    required this.currency,
    this.locale,
  });

  final String type;
  final double total;
  final String currency;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final style = accountTypeStyle(type);
    final colors = SecuroTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              style.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            formatMoney(total, currency: currency, locale: locale),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.account,
    required this.displayCurrency,
    required this.canEdit,
    this.locale,
  });

  final Account account;
  final String displayCurrency;
  final bool canEdit;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final style = accountTypeStyle(account.type);
    final text = Theme.of(context).textTheme;
    // balancePrimary is already converted server-side to the display
    // currency; currentBalance is in the account's own currency. Showing
    // either one with the wrong currency code silently misstates the
    // amount, so the code has to track which value ended up on screen.
    final usingPrimary = account.balancePrimary != null;
    final balance = account.balancePrimary ?? account.currentBalance;
    final balanceCurrency = usingPrimary ? displayCurrency : account.currency;

    return Pressable(
      onTap: () async {
        final deleted = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => AccountDetailScreen(account: account)),
        );
        if (deleted == true && context.mounted) {
          context.read<AccountsBloc>().add(const AccountsRequested());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: BorderRadius.circular(SecuroRadius.md),
              ),
              child: Icon(style.icon, size: 20, color: style.foreground),
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
                          account.label,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (account.isClosed) ...[
                        const SizedBox(width: 6),
                        _ClosedBadge(),
                      ],
                    ],
                  ),
                  if (account.maskedNumber != null ||
                      account.institutionName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (account.institutionName != null)
                          account.institutionName!,
                        if (account.maskedNumber != null)
                          '••${account.maskedNumber}',
                      ].join(' · '),
                      style: text.bodySmall
                          ?.copyWith(color: colors.mutedForeground),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatMoney(balance, currency: balanceCurrency, locale: locale),
              style: text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
            if (canEdit) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClosedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(SecuroRadius.sm),
      ),
      child: Text(
        'Closed',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.mutedForeground,
            ),
      ),
    );
  }
}

class _AccountsSkeleton extends StatelessWidget {
  const _AccountsSkeleton();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: [
              for (var g = 0; g < 2; g++) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: ShimmerBox(width: 120, height: 20),
                ),
                const SizedBox(height: 10),
                SecuroCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      for (var i = 0; i < 2; i++) ...[
                        if (i > 0) const SizedBox(height: 16),
                        Row(
                          children: [
                            const ShimmerBox(width: 40, height: 40, radius: 10),
                            const SizedBox(width: 12),
                            const Expanded(child: ShimmerBox(height: 14)),
                            const SizedBox(width: 12),
                            const ShimmerBox(width: 60, height: 14),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      );
}

