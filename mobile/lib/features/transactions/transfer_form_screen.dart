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
import '../accounts/accounts_screen.dart';
import 'transactions_screen.dart';

/// Moves money between two of the user's own accounts.
class TransferFormScreen extends ConsumerStatefulWidget {
  const TransferFormScreen({super.key});

  @override
  ConsumerState<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends ConsumerState<TransferFormScreen> {
  final _description = TextEditingController(text: 'Transfer');
  final _amount = TextEditingController();
  final _destinationAmount = TextEditingController();
  DateTime _date = DateTime.now();
  Account? _from;
  Account? _to;
  bool _saving = false;
  bool _loading = true;
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final accounts = await ref.read(accountsRepositoryProvider).list();
      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        _from = accounts.isNotEmpty ? accounts.first : null;
        _to = accounts.length > 1 ? accounts[1] : null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAppToast(context, '$error', isError: true);
    }
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _destinationAmount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime picked = _date;
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
                initialDateTime: _date,
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
    setState(() => _date = picked);
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) {
      showAppToast(context, 'Enter a valid amount', isError: true);
      return;
    }
    if (_from == null || _to == null) {
      showAppToast(context, 'Choose both accounts', isError: true);
      return;
    }
    if (_from!.id == _to!.id) {
      showAppToast(context, 'Choose two different accounts', isError: true);
      return;
    }
    final destinationAmount = _destinationAmount.text.trim().isEmpty
        ? null
        : double.tryParse(_destinationAmount.text.trim());

    setState(() => _saving = true);
    try {
      await ref.read(transactionsRepositoryProvider).createTransfer(
            fromAccountId: _from!.id,
            toAccountId: _to!.id,
            amount: amount,
            date: DateFormat('yyyy-MM-dd').format(_date),
            description: _description.text.trim().isEmpty ? 'Transfer' : _description.text.trim(),
            destinationAmount: destinationAmount,
          );
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
    final crossCurrency = _from != null && _to != null && _from!.currency != _to!.currency;

    return FormScreen(
      title: 'Transfer',
      saving: _saving,
      canSave: !_loading,
      onSave: _save,
      children: [
        LabeledField(
          label: 'From',
          child: Pressable(
            onTap: _loading
                ? null
                : () async {
                    final picked = await showPickerSheet<Account>(
                      context,
                      title: 'From account',
                      items: _accounts,
                      labelBuilder: (a) => a.label,
                      selected: _from,
                    );
                    if (picked != null) setState(() => _from = picked);
                  },
            child: _Box(colors: colors, child: Text(_from?.label ?? 'Choose an account')),
          ),
        ),
        LabeledField(
          label: 'To',
          child: Pressable(
            onTap: _loading
                ? null
                : () async {
                    final picked = await showPickerSheet<Account>(
                      context,
                      title: 'To account',
                      items: _accounts,
                      labelBuilder: (a) => a.label,
                      selected: _to,
                    );
                    if (picked != null) setState(() => _to = picked);
                  },
            child: _Box(colors: colors, child: Text(_to?.label ?? 'Choose an account')),
          ),
        ),
        LabeledField(
          label: _from == null ? 'Amount' : 'Amount (${_from!.currency})',
          child: TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        if (crossCurrency)
          LabeledField(
            label: 'Amount received (${_to!.currency}, optional)',
            child: TextField(
              controller: _destinationAmount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: 'Leave blank to convert at market rate'),
            ),
          ),
        LabeledField(
          label: 'Date',
          child: Pressable(
            onTap: _pickDate,
            child: _Box(colors: colors, child: Text(DateFormat.yMMMd().format(_date))),
          ),
        ),
        LabeledField(
          label: 'Description',
          child: TextField(controller: _description),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.child, required this.colors});
  final Widget child;
  final SecuroColors colors;

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
          Icon(Icons.unfold_more, size: 18, color: colors.mutedForeground),
        ],
      ),
    );
  }
}
