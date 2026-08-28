import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/format/color.dart';
import '../../core/format/money.dart';
import '../../core/privacy_mode.dart';
import '../../core/providers.dart';
import '../../core/responsive.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/pressable.dart';
import '../../models/category.dart';
import '../../models/transaction.dart';
import '../categories/categories_screen.dart';
import '../rules/rule_form_screen.dart';
import '../workspace/workspace_controller.dart';
import 'attachments_repository.dart';
import 'bloc/transactions_bloc.dart';
import 'transaction_filters_sheet.dart';
import 'transaction_form_screen.dart';
import 'transactions_repository.dart';
import 'transfer_form_screen.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>(
  (ref) => TransactionsRepository(ref.watch(apiClientProvider)),
);

final attachmentsRepositoryProvider = Provider<AttachmentsRepository>(
  (ref) => AttachmentsRepository(ref.watch(apiClientProvider)),
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
  bool _selecting = false;
  final Set<String> _selectedIds = {};

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

  void _toggleSelectionMode() {
    setState(() {
      _selecting = !_selecting;
      _selectedIds.clear();
    });
  }

  void _toggleSelected(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _bulkDelete() async {
    final confirmed = await confirmDelete(
      context,
      title: 'Delete ${_selectedIds.length} transactions?',
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(transactionsRepositoryProvider).bulkDelete(_selectedIds.toList());
      if (!mounted) return;
      _toggleSelectionMode();
      context.read<TransactionsBloc>().add(const TransactionsRequested());
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _bulkCategorize() async {
    List<Category> categories;
    try {
      categories = await ref.read(categoriesRepositoryProvider).list();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
      return;
    }
    if (!mounted) return;
    final picked = await showPickerSheet<Category>(
      context,
      title: 'Set category',
      items: categories,
      labelBuilder: (c) => c.name,
    );
    if (picked == null || !mounted) return;
    try {
      await ref
          .read(transactionsRepositoryProvider)
          .bulkCategorize(_selectedIds.toList(), picked.id);
      if (!mounted) return;
      _toggleSelectionMode();
      context.read<TransactionsBloc>().add(const TransactionsRequested());
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(currentWorkspaceProvider).valueOrNull?.locale;
    final state = context.watch<TransactionsBloc>().state;
    final colors = SecuroTheme.of(context);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return LargeTitleScrollView(
      title: _selecting ? '${_selectedIds.length} selected' : 'Transactions',
      controller: _scrollController,
      onRefresh: () async {
        context.read<TransactionsBloc>().add(const TransactionsRefreshed());
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      actions: _selecting
          ? (!canEdit
              ? null
              : [
                  IconButton(
                    icon: const Icon(Icons.sell_outlined),
                    tooltip: 'Set category',
                    onPressed: _selectedIds.isEmpty ? null : _bulkCategorize,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete',
                    onPressed: _selectedIds.isEmpty ? null : _bulkDelete,
                  ),
                  TextButton(
                    onPressed: _toggleSelectionMode,
                    child: const Text('Done'),
                  ),
                ])
          : [
              Consumer(
                builder: (context, ref, _) {
                  final privacyMode = ref.watch(privacyModeProvider);
                  return IconButton(
                    icon: Icon(privacyMode ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    tooltip: privacyMode ? 'Show amounts' : 'Hide amounts',
                    onPressed: () => ref.read(privacyModeProvider.notifier).toggle(),
                  );
                },
              ),
              if (canEdit) ...[
                  Builder(
                    builder: (context) => IconButton(
                      icon: Badge(
                        isLabelVisible: state.filters.activeCount > 0,
                        label: Text('${state.filters.activeCount}'),
                        child: const Icon(Icons.filter_list),
                      ),
                      tooltip: 'Filter',
                      onPressed: () async {
                        final picked = await showTransactionFiltersSheet(
                          context,
                          current: state.filters,
                        );
                        if (picked != null && context.mounted) {
                          context
                              .read<TransactionsBloc>()
                              .add(TransactionsFiltersChanged(picked));
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.checklist),
                    tooltip: 'Select',
                    onPressed: _toggleSelectionMode,
                  ),
                  Builder(
                    builder: (context) => PopupMenuButton<String>(
                      icon: const Icon(Icons.add),
                      onSelected: (value) async {
                        final created = await pushFormScreen<bool>(
                          context,
                          value == 'transfer'
                              ? const TransferFormScreen()
                              : const TransactionFormScreen(),
                        );
                        if (created == true && context.mounted) {
                          context.read<TransactionsBloc>().add(const TransactionsRequested());
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'transaction', child: Text('New transaction')),
                        PopupMenuItem(value: 'transfer', child: Text('Transfer between accounts')),
                      ],
                    ),
                  ),
                ],
            ],
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            context.responsive.pagePadding,
            8,
            context.responsive.pagePadding,
            4,
          ),
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
                  title: state.query.isNotEmpty
                      ? 'No matches for "${state.query}"'
                      : !state.filters.isEmpty
                          ? 'No transactions match these filters'
                          : 'No transactions yet',
                  message: state.query.isEmpty && state.filters.isEmpty
                      ? 'Transactions from your accounts show up here.'
                      : null,
                ),
              ),
            ],
          _ => _transactionSlivers(
              state: state,
              locale: locale,
              canEdit: canEdit,
              selecting: _selecting,
              selectedIds: _selectedIds,
              horizontalPadding: context.responsive.pagePadding,
              onLongPressStart: _selecting ? null : (id) {
                _toggleSelectionMode();
                _toggleSelected(id);
              },
              onToggleSelected: _toggleSelected,
            ),
        },
      ],
    );
  }
}

List<Widget> _transactionSlivers({
  required TransactionsState state,
  required bool canEdit,
  required bool selecting,
  required Set<String> selectedIds,
  required void Function(String id)? onLongPressStart,
  required void Function(String id) onToggleSelected,
  required double horizontalPadding,
  String? locale,
}) {
  final grouped = state.groupedByDate;
  final days = grouped.keys.toList();

  return [
    SliverPadding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 100),
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
                        _TransactionTile(
                          transaction: txs[i],
                          locale: locale,
                          canEdit: canEdit,
                          selecting: selecting,
                          selected: selectedIds.contains(txs[i].id),
                          onLongPressStart: onLongPressStart,
                          onToggleSelected: onToggleSelected,
                        ),
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

class _TransactionTile extends ConsumerWidget {
  const _TransactionTile({
    required this.transaction,
    required this.canEdit,
    required this.selecting,
    required this.selected,
    required this.onLongPressStart,
    required this.onToggleSelected,
    this.locale,
  });

  final Transaction transaction;
  final bool canEdit;
  final bool selecting;
  final bool selected;
  final void Function(String id)? onLongPressStart;
  final void Function(String id) onToggleSelected;
  final String? locale;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved = await pushFormScreen<bool>(
      context,
      TransactionFormScreen(transaction: transaction),
    );
    if (saved == true && context.mounted) {
      context.read<TransactionsBloc>().add(const TransactionsRequested());
    }
  }

  Future<void> _openActions(BuildContext context, WidgetRef ref) async {
    if (!canEdit) return;
    final repo = ref.read(transactionsRepositoryProvider);
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          transaction.description.isNotEmpty ? transaction.description : 'Transaction',
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('edit'),
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('duplicate'),
            child: const Text('Duplicate'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('ignore'),
            child: Text(transaction.isIgnored ? 'Unignore' : 'Ignore'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('create_rule'),
            child: const Text('Create rule from this'),
          ),
          if (transaction.recurringTransactionId != null)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop('unlink_recurring'),
              child: const Text('Unlink from recurring'),
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
      case 'edit':
        await _edit(context);
      case 'duplicate':
        try {
          await repo.duplicate(transaction);
          if (context.mounted) {
            context.read<TransactionsBloc>().add(const TransactionsRequested());
          }
        } catch (error) {
          if (context.mounted) showAppToast(context, '$error', isError: true);
        }
      case 'ignore':
        try {
          await repo.toggleIgnore(transaction.id);
          if (context.mounted) {
            context.read<TransactionsBloc>().add(const TransactionsRequested());
          }
        } catch (error) {
          if (context.mounted) showAppToast(context, '$error', isError: true);
        }
      case 'create_rule':
        await pushFormScreen<bool>(
          context,
          RuleFormScreen(
            initialName: transaction.description.isNotEmpty
                ? transaction.description
                : transaction.payeeName,
            initialCondition: {
              'field': 'description',
              'op': 'contains',
              'value': transaction.description.isNotEmpty
                  ? transaction.description
                  : (transaction.payeeName ?? ''),
            },
          ),
        );
      case 'unlink_recurring':
        try {
          await repo.unlinkRecurring(transaction.id);
          if (context.mounted) {
            context.read<TransactionsBloc>().add(const TransactionsRequested());
          }
        } catch (error) {
          if (context.mounted) showAppToast(context, '$error', isError: true);
        }
      case 'delete':
        String applyTo = 'this';
        if (transaction.installmentSeriesId != null) {
          final scope = await showCupertinoModalPopup<String>(
            context: context,
            builder: (context) => CupertinoActionSheet(
              title: const Text('Delete installment'),
              message: const Text('This is part of an installment series.'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(context).pop('this'),
                  child: const Text('Just this one'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(context).pop('future'),
                  child: const Text('This and future'),
                ),
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.of(context).pop('all'),
                  child: const Text('The whole series'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          );
          if (scope == null || !context.mounted) return;
          applyTo = scope;
        } else {
          final confirmed = await confirmDelete(
            context,
            title: 'Delete this transaction?',
          );
          if (!confirmed || !context.mounted) return;
        }
        try {
          await repo.delete(transaction.id, applyTo: applyTo);
          if (context.mounted) {
            context.read<TransactionsBloc>().add(const TransactionsRequested());
          }
        } catch (error) {
          if (context.mounted) showAppToast(context, '$error', isError: true);
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;
    final amount = transaction.displayAmount;
    final categoryColor = parseHexColor(transaction.category?.color) ?? colors.muted;
    final ignored = transaction.isIgnored;
    final privacyMode = ref.watch(privacyModeProvider);

    return Pressable(
      onTap: selecting
          ? () => onToggleSelected(transaction.id)
          : () => _edit(context),
      onLongPress: selecting || !canEdit || onLongPressStart == null
          ? null
          : () => onLongPressStart!(transaction.id),
      child: Opacity(
        opacity: ignored ? 0.5 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              if (selecting) ...[
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 22,
                  color: selected ? colors.primary : colors.mutedForeground,
                ),
                const SizedBox(width: 10),
              ],
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(SecuroRadius.md),
                ),
                alignment: Alignment.center,
                child: transaction.transferPairId != null
                    ? Icon(Icons.swap_horiz, size: 18, color: categoryColor)
                    : Text(
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            transaction.description.isNotEmpty
                                ? transaction.description
                                : (transaction.payeeName ?? 'Transaction'),
                            overflow: TextOverflow.ellipsis,
                            style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (transaction.status == TransactionStatus.pending) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.schedule, size: 13, color: colors.mutedForeground),
                        ],
                        if (transaction.recurringTransactionId != null) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.repeat, size: 13, color: colors.mutedForeground),
                        ],
                        if (transaction.attachmentCount > 0) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.attach_file, size: 13, color: colors.mutedForeground),
                        ],
                        if (transaction.isShared) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.people_outline, size: 13, color: colors.mutedForeground),
                        ],
                      ],
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
                privacyMode
                    ? kPrivacyMask
                    : formatSignedMoney(amount, currency: transaction.currency, locale: locale),
                // Sign prefix (+/-) carries the meaning; Apple's own list-value
                // convention (iOS Wallet) keeps amounts grayscale rather than
                // color-coding income/expense.
                style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (canEdit && !selecting) ...[
                const SizedBox(width: 2),
                Pressable(
                  onTap: () => _openActions(context, ref),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.more_vert, size: 18, color: colors.mutedForeground),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionsSkeleton extends StatelessWidget {
  const _TransactionsSkeleton();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: EdgeInsets.fromLTRB(
          context.responsive.pagePadding,
          8,
          context.responsive.pagePadding,
          24,
        ),
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
