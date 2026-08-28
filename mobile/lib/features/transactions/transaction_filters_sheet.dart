import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/panels.dart';
import '../../models/account.dart';
import '../../models/category.dart';
import '../../models/payee.dart';
import '../accounts/accounts_screen.dart';
import '../categories/categories_screen.dart';
import '../payees/payees_screen.dart';
import 'transactions_repository.dart';

/// Shows the filter sheet, seeded with [current], and returns the edited
/// filters — or null if the sheet was dismissed without tapping Apply.
Future<TransactionFilters?> showTransactionFiltersSheet(
  BuildContext context, {
  required TransactionFilters current,
}) {
  return showModalBottomSheet<TransactionFilters>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FiltersSheet(initial: current),
  );
}

const _kTypes = [('debit', 'Expense'), ('credit', 'Income')];
const _kStatuses = [('posted', 'Posted'), ('pending', 'Pending')];

class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet({required this.initial});
  final TransactionFilters initial;

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  late TransactionFilters _filters = widget.initial;
  late final _minAmount =
      TextEditingController(text: widget.initial.minAmount?.toString() ?? '');
  late final _maxAmount =
      TextEditingController(text: widget.initial.maxAmount?.toString() ?? '');

  bool _loading = true;
  List<Account> _accounts = [];
  List<Category> _categories = [];
  List<Payee> _payees = [];

  @override
  void initState() {
    super.initState();
    _loadRefs();
  }

  @override
  void dispose() {
    _minAmount.dispose();
    _maxAmount.dispose();
    super.dispose();
  }

  Future<void> _loadRefs() async {
    try {
      final results = await Future.wait([
        ref.read(accountsRepositoryProvider).list(),
        ref.read(categoriesRepositoryProvider).list(),
        ref.read(payeesRepositoryProvider).list(),
      ]);
      if (!mounted) return;
      setState(() {
        _accounts = results[0] as List<Account>;
        _categories = results[1] as List<Category>;
        _payees = results[2] as List<Payee>;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = DateTime.tryParse(
          (isFrom ? _filters.fromDate : _filters.toDate) ?? '',
        ) ??
        DateTime.now();
    DateTime picked = initial;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 260,
        color: SecuroTheme.of(context).card,
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initial,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (value) => picked = value,
              ),
            ),
            SafeArea(
              top: false,
              child: CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
    final formatted = DateFormat('yyyy-MM-dd').format(picked);
    setState(() {
      _filters = isFrom
          ? _filters.copyWith(fromDate: formatted)
          : _filters.copyWith(toDate: formatted);
    });
  }

  void _toggleAccount(String id) {
    final ids = List<String>.from(_filters.accountIds);
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    setState(() => _filters = _filters.copyWith(accountIds: ids));
  }

  void _toggleCategory(String id) {
    final ids = List<String>.from(_filters.categoryIds);
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    setState(() => _filters = _filters.copyWith(categoryIds: ids));
  }

  Future<void> _pickPayee() async {
    final selected = _payees.where((p) => p.id == _filters.payeeId).firstOrNull;
    final picked = await showPickerSheet<Payee?>(
      context,
      title: 'Payee',
      items: _payees,
      labelBuilder: (p) => p!.name,
      selected: selected,
      allowNone: true,
    );
    setState(() {
      _filters =
          picked == null ? _filters.copyWith(clearPayeeId: true) : _filters.copyWith(payeeId: picked.id);
    });
  }

  void _apply() {
    final min = double.tryParse(_minAmount.text.trim());
    final max = double.tryParse(_maxAmount.text.trim());
    Navigator.of(context).pop(
      _filters.copyWith(
        minAmount: min,
        clearMinAmount: min == null,
        maxAmount: max,
        clearMaxAmount: max == null,
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _filters = const TransactionFilters();
      _minAmount.clear();
      _maxAmount.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(SecuroRadius.panel)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 5,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(SecuroRadius.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Filters', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  if (!_filters.isEmpty)
                    TextButton(onPressed: _clearAll, child: const Text('Clear all')),
                ],
              ),
            ),
            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  children: [
                    Text('Type', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final t in _kTypes)
                          ChoiceChip(
                            label: Text(t.$2),
                            selected: _filters.type == t.$1,
                            onSelected: (selected) => setState(() {
                              _filters = selected
                                  ? _filters.copyWith(type: t.$1)
                                  : _filters.copyWith(clearType: true);
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Status', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final s in _kStatuses)
                          ChoiceChip(
                            label: Text(s.$2),
                            selected: _filters.status == s.$1,
                            onSelected: (selected) => setState(() {
                              _filters = selected
                                  ? _filters.copyWith(status: s.$1)
                                  : _filters.copyWith(clearStatus: true);
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Date range', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _DateBox(
                            label: _filters.fromDate ?? 'From',
                            onTap: () => _pickDate(isFrom: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _DateBox(
                            label: _filters.toDate ?? 'To',
                            onTap: () => _pickDate(isFrom: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Amount range', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minAmount,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(hintText: 'Min'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _maxAmount,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(hintText: 'Max'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GroupedPanel(
                      children: [
                        GroupedRow(
                          label: 'Hide ignored',
                          trailing: Switch(
                            value: _filters.excludeIgnored,
                            onChanged: (v) =>
                                setState(() => _filters = _filters.copyWith(excludeIgnored: v)),
                          ),
                        ),
                        GroupedRow(
                          label: 'Uncategorized only',
                          trailing: Switch(
                            value: _filters.uncategorized,
                            onChanged: (v) =>
                                setState(() => _filters = _filters.copyWith(uncategorized: v)),
                          ),
                        ),
                        GroupedRow(
                          label: 'Payee',
                          subtitle: _payees.where((p) => p.id == _filters.payeeId).firstOrNull?.name,
                          onTap: _pickPayee,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Accounts', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    GroupedPanel(
                      children: [
                        for (final account in _accounts)
                          GroupedRow(
                            label: account.label,
                            trailing: Checkbox(
                              value: _filters.accountIds.contains(account.id),
                              onChanged: (_) => _toggleAccount(account.id),
                            ),
                            onTap: () => _toggleAccount(account.id),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Categories', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    GroupedPanel(
                      children: [
                        for (final category in _categories)
                          GroupedRow(
                            label: category.name,
                            trailing: Checkbox(
                              value: _filters.categoryIds.contains(category.id),
                              onChanged: (_) => _toggleCategory(category.id),
                            ),
                            onTap: () => _toggleCategory(category.id),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: FilledButton(
                  onPressed: _apply,
                  child: const Text('Apply filters'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(SecuroRadius.md),
          border: Border.all(color: colors.input),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
            Icon(Icons.calendar_today_outlined, size: 15, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
