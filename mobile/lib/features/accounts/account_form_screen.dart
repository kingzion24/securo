import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/currencies.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/account.dart';
import 'account_type.dart';
import 'accounts_screen.dart';

const _kAccountTypes = ['checking', 'savings', 'credit_card', 'investment', 'wallet'];

/// Create (account == null) or edit (account != null) an account. Currency
/// is fixed once created — the server has no "convert an account's own
/// currency" operation, matching the web app's edit dialog which hides that
/// field for an existing account too.
class AccountFormScreen extends ConsumerStatefulWidget {
  const AccountFormScreen({this.account, super.key});
  final Account? account;

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  late final _name = TextEditingController(text: widget.account?.name ?? '');
  late final _balance = TextEditingController(
    text: widget.account == null ? '0' : widget.account!.currentBalance.toString(),
  );
  late final _creditLimit =
      TextEditingController(text: widget.account?.creditLimit?.toString() ?? '');
  late String _type = widget.account?.type ?? _kAccountTypes.first;
  late String _currency = widget.account?.currency ?? kCurrencyOptions.first;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _balance.dispose();
    _creditLimit.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    final balance = double.tryParse(_balance.text.trim());
    if (balance == null) {
      showAppToast(context, 'Enter a valid balance', isError: true);
      return;
    }
    final creditLimit =
        _creditLimit.text.trim().isEmpty ? null : double.tryParse(_creditLimit.text.trim());

    setState(() => _saving = true);
    final repo = ref.read(accountsRepositoryProvider);
    try {
      if (widget.account == null) {
        await repo.create(
          name: name,
          type: _type,
          balance: balance,
          currency: _currency,
          creditLimit: creditLimit,
        );
      } else {
        await repo.update(
          widget.account!.id,
          name: name,
          type: _type,
          balance: balance,
          creditLimit: creditLimit,
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
      title: widget.account == null ? 'New Account' : 'Edit Account',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Type',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final type in _kAccountTypes)
                _TypeChip(
                  type: type,
                  selected: type == _type,
                  onTap: () => setState(() => _type = type),
                ),
            ],
          ),
        ),
        LabeledField(
          label: 'Name',
          child: TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'e.g. Everyday Checking'),
          ),
        ),
        LabeledField(
          label: widget.account == null ? 'Starting balance' : 'Balance',
          child: TextField(
            controller: _balance,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          ),
        ),
        if (widget.account == null)
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
              child: _PickerField(value: _currency, colors: colors),
            ),
          ),
        if (_type == 'credit_card')
          LabeledField(
            label: 'Credit limit',
            child: TextField(
              controller: _creditLimit,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type, required this.selected, required this.onTap});
  final String type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final style = accountTypeStyle(type);
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? style.background : colors.muted,
          borderRadius: BorderRadius.circular(SecuroRadius.pill),
          border: selected ? Border.all(color: style.foreground) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(style.icon, size: 15, color: selected ? style.foreground : colors.mutedForeground),
            const SizedBox(width: 6),
            Text(
              style.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? style.foreground : colors.mutedForeground,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({required this.value, required this.colors});
  final String value;
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
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
          Icon(Icons.unfold_more, size: 18, color: colors.mutedForeground),
        ],
      ),
    );
  }
}
