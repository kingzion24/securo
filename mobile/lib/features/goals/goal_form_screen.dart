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
import '../../models/goal.dart';
import 'goals_screen.dart';

class GoalFormScreen extends ConsumerStatefulWidget {
  const GoalFormScreen({this.goal, super.key});
  final GoalSummary? goal;

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  late final _name = TextEditingController(text: widget.goal?.name ?? '');
  late final _target =
      TextEditingController(text: widget.goal?.targetAmount.toString() ?? '');
  late final _current =
      TextEditingController(text: widget.goal?.currentAmount.toString() ?? '0');
  late String _currency = widget.goal?.currency ?? kCurrencyOptions.first;
  DateTime? _targetDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _targetDate =
        widget.goal?.targetDate != null ? DateTime.tryParse(widget.goal!.targetDate!) : null;
  }

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _current.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime picked = _targetDate ?? DateTime.now();
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
                initialDateTime: picked,
                minimumDate: DateTime.now(),
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
    setState(() => _targetDate = picked);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final target = double.tryParse(_target.text.trim());
    final current = double.tryParse(_current.text.trim()) ?? 0;
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    if (target == null || target <= 0) {
      showAppToast(context, 'Enter a valid target amount', isError: true);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(goalsRepositoryProvider);
    final dateStr = _targetDate == null ? null : DateFormat('yyyy-MM-dd').format(_targetDate!);
    try {
      if (widget.goal == null) {
        await repo.create(
          name: name,
          targetAmount: target,
          currentAmount: current,
          currency: _currency,
          targetDate: dateStr,
        );
      } else {
        await repo.update(
          widget.goal!.id,
          name: name,
          targetAmount: target,
          currentAmount: current,
          targetDate: dateStr,
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
      title: widget.goal == null ? 'New Goal' : 'Edit Goal',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Name',
          child: TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'e.g. Emergency fund'),
          ),
        ),
        LabeledField(
          label: 'Target amount',
          child: TextField(
            controller: _target,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        LabeledField(
          label: 'Current amount',
          child: TextField(
            controller: _current,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        if (widget.goal == null)
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
                child: Row(
                  children: [
                    Expanded(child: Text(_currency)),
                    Icon(Icons.unfold_more, size: 18, color: colors.mutedForeground),
                  ],
                ),
              ),
            ),
          ),
        LabeledField(
          label: 'Target date (optional)',
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _targetDate == null ? 'None' : DateFormat.yMMMd().format(_targetDate!),
                      style: TextStyle(
                        color: _targetDate == null ? colors.mutedForeground : null,
                      ),
                    ),
                  ),
                  if (_targetDate != null)
                    Pressable(
                      onTap: () => setState(() => _targetDate = null),
                      child: Icon(Icons.close, size: 18, color: colors.mutedForeground),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
