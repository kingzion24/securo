import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/account.dart';
import '../../models/category.dart';
import '../../models/recurring_transaction.dart';
import '../accounts/accounts_screen.dart';
import '../categories/categories_screen.dart';
import 'recurring_screen.dart';

const _kFrequencies = ['weekly', 'monthly', 'quarterly', 'yearly'];

class RecurringFormScreen extends ConsumerStatefulWidget {
  const RecurringFormScreen({this.item, super.key});
  final RecurringTransaction? item;

  @override
  ConsumerState<RecurringFormScreen> createState() => _RecurringFormScreenState();
}

class _RecurringFormScreenState extends ConsumerState<RecurringFormScreen> {
  late final _description = TextEditingController(text: widget.item?.description ?? '');
  late final _amount =
      TextEditingController(text: widget.item?.amount.toString() ?? '');
  late String _type = widget.item?.type ?? 'debit';
  late String _frequency = widget.item?.frequency ?? 'monthly';
  DateTime _startDate = DateTime.now();
  Account? _account;
  Category? _category;
  bool _saving = false;
  bool _loadingPickers = true;
  List<Account> _accounts = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        ref.read(accountsRepositoryProvider).list(),
        ref.read(categoriesRepositoryProvider).list(),
      ]);
      if (!mounted) return;
      setState(() {
        _accounts = results[0] as List<Account>;
        _categories = results[1] as List<Category>;
        _account = widget.item?.accountId == null
            ? (_accounts.isNotEmpty ? _accounts.first : null)
            : _accounts.where((a) => a.id == widget.item!.accountId).firstOrNull;
        if (widget.item?.categoryId != null) {
          _category = _categories.where((c) => c.id == widget.item!.categoryId).firstOrNull;
        }
        _loadingPickers = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingPickers = false);
      showAppToast(context, '$error', isError: true);
    }
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    DateTime picked = _startDate;
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
                initialDateTime: _startDate,
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
    setState(() => _startDate = picked);
  }

  Future<void> _save() async {
    final description = _description.text.trim();
    final amount = double.tryParse(_amount.text.trim());
    if (description.isEmpty) {
      showAppToast(context, 'Enter a description', isError: true);
      return;
    }
    if (amount == null || amount <= 0) {
      showAppToast(context, 'Enter a valid amount', isError: true);
      return;
    }
    if (widget.item == null && _account == null) {
      showAppToast(context, 'Choose an account', isError: true);
      return;
    }

    setState(() => _saving = true);
    final repo = ref.read(recurringRepositoryProvider);
    try {
      if (widget.item == null) {
        await repo.create(
          description: description,
          amount: amount,
          type: _type,
          frequency: _frequency,
          startDate: DateFormat('yyyy-MM-dd').format(_startDate),
          accountId: _account!.id,
          categoryId: _category?.id,
        );
      } else {
        await repo.update(
          widget.item!.id,
          description: description,
          amount: amount,
          type: _type,
          frequency: _frequency,
          categoryId: _category?.id,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      showAppToast(context, '$error', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return FormScreen(
      title: widget.item == null ? 'New Recurring' : 'Edit Recurring',
      saving: _saving,
      canSave: !_loadingPickers,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Type',
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'debit', label: Text('Expense')),
              ButtonSegment(value: 'credit', label: Text('Income')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
        ),
        LabeledField(
          label: 'Description',
          child: TextField(
            controller: _description,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'e.g. Netflix'),
          ),
        ),
        LabeledField(
          label: 'Amount',
          child: TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        LabeledField(
          label: 'Frequency',
          child: Wrap(
            spacing: 8,
            children: [
              for (final f in _kFrequencies)
                ChoiceChip(
                  label: Text(f[0].toUpperCase() + f.substring(1)),
                  selected: f == _frequency,
                  onSelected: (_) => setState(() => _frequency = f),
                ),
            ],
          ),
        ),
        if (widget.item == null) ...[
          LabeledField(
            label: 'Starts',
            child: Pressable(
              onTap: _pickStartDate,
              child: _Box(
                colors: colors,
                child: Text(DateFormat.yMMMd().format(_startDate)),
              ),
            ),
          ),
          LabeledField(
            label: 'Account',
            child: Pressable(
              onTap: _loadingPickers
                  ? null
                  : () async {
                      final picked = await showPickerSheet<Account>(
                        context,
                        title: 'Account',
                        items: _accounts,
                        labelBuilder: (a) => a.label,
                        selected: _account,
                      );
                      if (picked != null) setState(() => _account = picked);
                    },
              child: _Box(
                colors: colors,
                loading: _loadingPickers,
                child: Text(
                  _account?.label ?? 'Choose an account',
                  style: TextStyle(color: _account == null ? colors.mutedForeground : null),
                ),
              ),
            ),
          ),
        ],
        LabeledField(
          label: 'Category',
          child: Pressable(
            onTap: _loadingPickers
                ? null
                : () async {
                    final picked = await showPickerSheet<Category?>(
                      context,
                      title: 'Category',
                      items: _categories,
                      labelBuilder: (c) => c!.name,
                      selected: _category,
                      allowNone: true,
                    );
                    setState(() => _category = picked);
                  },
            child: _Box(
              colors: colors,
              loading: _loadingPickers,
              child: Text(
                _category?.name ?? 'None',
                style: TextStyle(color: _category == null ? colors.mutedForeground : null),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.child, required this.colors, this.loading = false});
  final Widget child;
  final SecuroColors colors;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.input),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          if (loading)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: colors.mutedForeground),
            )
          else
            Icon(Icons.unfold_more, size: 18, color: colors.mutedForeground),
        ],
      ),
    );
  }
}
