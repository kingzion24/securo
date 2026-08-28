import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/format/color.dart';
import '../../core/format/money.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/pressable.dart';
import '../../models/transaction.dart';
import '../workspace/workspace_controller.dart';
import 'bloc/transactions_bloc.dart';
import 'transactions_repository.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>(
  (ref) => TransactionsRepository(ref.watch(apiClientProvider)),
);

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(transactionsRepositoryProvider);
    return BlocProvider(
      create: (_) =>
          TransactionsBloc(repository)..add(const TransactionsRequested()),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends ConsumerStatefulWidget {
  const _TransactionsView();

  @override
  ConsumerState<_TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends ConsumerState<_TransactionsView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 400) {
      context.read<TransactionsBloc>().add(const TransactionsMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(currentWorkspaceProvider).valueOrNull?.locale;
    final state = context.watch<TransactionsBloc>().state;
    final colors = SecuroTheme.of(context);

    return LargeTitleScrollView(
      title: 'Transactions',
      controller: _scrollController,
      onRefresh: () async {
        context.read<TransactionsBloc>().add(const TransactionsRefreshed());
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          sliver: SliverToBoxAdapter(
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Search transactions',
              backgroundColor: colors.muted,
              style: TextStyle(color: colors.foreground),
              onChanged: (value) => context
                  .read<TransactionsBloc>()
                  .add(TransactionsSearched(value)),
            ),
          ),
        ),
        ...switch (state.status) {
          TransactionsStatus.initial ||
          TransactionsStatus.loading =>
            const [_TransactionsSkeleton()],
          TransactionsStatus.failure when state.transactions.isEmpty => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorState(
                  message: state.error ?? 'Could not load transactions',
                  onRetry: () => context
                      .read<TransactionsBloc>()
                      .add(const TransactionsRequested()),
                ),
              ),
            ],
          _ when state.transactions.isEmpty => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.swap_horiz,
                  title: state.query.isEmpty
                      ? 'No transactions yet'
                      : 'No matches for "${state.query}"',
                  message: state.query.isEmpty
                      ? 'Transactions from your accounts show up here.'
                      : null,
                ),
              ),
            ],
          _ => _transactionSlivers(state: state, locale: locale),
        },
      ],
    );
  }
}

List<Widget> _transactionSlivers({
  required TransactionsState state,
  String? locale,
}) {
  final grouped = state.groupedByDate;
  final days = grouped.keys.toList();

  return [
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      sliver: SliverList.builder(
        itemCount:
            days.length + (state.status == TransactionsStatus.loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= days.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          final day = days[index];
          final txs = grouped[day]!;
          final colors = SecuroTheme.of(context);
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                  child: Text(
                    _dayLabel(day, locale),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colors.mutedForeground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                SecuroCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (var i = 0; i < txs.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: colors.border),
                        _TransactionTile(transaction: txs[i], locale: locale),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  ];
}

String _dayLabel(String isoDate, String? locale) {
  final date = DateTime.tryParse(isoDate);
  if (date == null) return isoDate;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final that = DateTime(date.year, date.month, date.day);
  final diff = today.difference(that).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return DateFormat.yMMMd(locale).format(date);
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction, this.locale});

  final Transaction transaction;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;
    final amount = transaction.displayAmount;
    final categoryColor = parseHexColor(transaction.category?.color) ?? colors.muted;

    return Pressable(
      onTap: () {
        // Transaction detail is a later slice.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(SecuroRadius.md),
              ),
              alignment: Alignment.center,
              child: Text(
                transaction.category?.icon.isNotEmpty == true
                    ? transaction.category!.icon
                    : (amount >= 0 ? '↓' : '↑'),
                style: TextStyle(fontSize: 18, color: categoryColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description.isNotEmpty
                        ? transaction.description
                        : (transaction.payeeName ?? 'Transaction'),
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (transaction.category != null ||
                      transaction.payeeName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (transaction.payeeName != null) transaction.payeeName!,
                        if (transaction.category != null)
                          transaction.category!.name,
                      ].join(' · '),
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(color: colors.mutedForeground),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatSignedMoney(amount, currency: transaction.currency, locale: locale),
              // Sign prefix (+/-) carries the meaning; Apple's own list-value
              // convention (iOS Wallet) keeps amounts grayscale rather than
              // color-coding income/expense.
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionsSkeleton extends StatelessWidget {
  const _TransactionsSkeleton();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: [
              for (var g = 0; g < 3; g++) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: ShimmerBox(width: 80, height: 16),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      );
}
