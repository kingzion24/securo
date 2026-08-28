import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/format/currencies.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/loan.dart';
import 'loans_screen.dart';

class LoanFormScreen extends ConsumerStatefulWidget {
  const LoanFormScreen({this.loan, super.key});
  final Loan? loan;

  @override
  ConsumerState<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends ConsumerState<LoanFormScreen> {
  late final _personName = TextEditingController(text: widget.loan?.personName ?? '');
  late final _amount =
      TextEditingController(text: widget.loan?.principalAmount.toString() ?? '');
  late final _note = TextEditingController();
  late String _direction = widget.loan?.direction ?? 'they_owe_me';
  late String _currency = widget.loan?.currency ?? kCurrencyOptions.first;
  late DateTime _date =
      widget.loan == null ? DateTime.now() : DateTime.parse(widget.loan!.date);
  bool _saving = false;

  @override
  void dispose() {
    _personName.dispose();
    _amount.dispose();
    _note.dispose();
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
    final name = _personName.text.trim();
    final amount = double.tryParse(_amount.text.trim());
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    if (amount == null || amount <= 0) {
      showAppToast(context, 'Enter a valid amount', isError: true);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(loansRepositoryProvider);
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();
    try {
      if (widget.loan == null) {
        await repo.create(
          personName: name,
          direction: _direction,
          principalAmount: amount,
          date: DateFormat('yyyy-MM-dd').format(_date),
          currency: _currency,
          note: note,
        );
      } else {
        await repo.update(
          widget.loan!.id,
          personName: name,
          direction: _direction,
          principalAmount: amount,
          currency: _currency,
          date: DateFormat('yyyy-MM-dd').format(_date),
          note: note,
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
      title: widget.loan == null ? 'New Loan' : 'Edit Loan',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Direction',
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'they_owe_me', label: Text('They owe me')),
              ButtonSegment(value: 'i_owe_them', label: Text('I owe them')),
            ],
            selected: {_direction},
            onSelectionChanged: (s) => setState(() => _direction = s.first),
          ),
        ),
        LabeledField(
          label: 'Person',
          child: TextField(
            controller: _personName,
            textCapitalization: TextCapitalization.words,
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
          label: 'Currency',
          child: Pressable(
            onTap: () async {
              final picked = await showPickerSheet<String>(
                context,
                title: 'Currency',
                items: kCurrencyOptions,
                labelBuilder: (c) => c,
                selected: _currency,
              );
              if (picked != null) setState(() => _currency = picked);
            },
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(SecuroRadius.md),
                border: Border.all(color: colors.input),
              ),
              child: Row(children: [Expanded(child: Text(_currency))]),
            ),
          ),
        ),
        LabeledField(
          label: 'Date',
          child: Pressable(
            onTap: _pickDate,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(SecuroRadius.md),
                border: Border.all(color: colors.input),
              ),
              child: Row(children: [Text(DateFormat.yMMMd().format(_date))]),
            ),
          ),
        ),
        LabeledField(
          label: 'Note',
          child: TextField(controller: _note, maxLines: 3),
        ),
      ],
    );
  }
}
