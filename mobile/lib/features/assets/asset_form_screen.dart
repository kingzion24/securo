import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/currencies.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/asset.dart';
import 'assets_screen.dart';

const _kAssetTypes = ['cash', 'investment', 'real_estate', 'vehicle', 'other'];

/// Manual-valuation assets only — see the repository doc for why.
class AssetFormScreen extends ConsumerStatefulWidget {
  const AssetFormScreen({this.asset, super.key});
  final Asset? asset;

  @override
  ConsumerState<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends ConsumerState<AssetFormScreen> {
  late final _name = TextEditingController(text: widget.asset?.name ?? '');
  late final _value =
      TextEditingController(text: widget.asset?.currentValue?.toString() ?? '');
  late final _units = TextEditingController(text: widget.asset?.units?.toString() ?? '');
  late String _type = widget.asset?.type ?? _kAssetTypes.first;
  late String _currency = widget.asset?.currency ?? kCurrencyOptions.first;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _value.dispose();
    _units.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    final value = double.tryParse(_value.text.trim());
    final units = _units.text.trim().isEmpty ? null : double.tryParse(_units.text.trim());

    setState(() => _saving = true);
    final repo = ref.read(assetsRepositoryProvider);
    try {
      if (widget.asset == null) {
        await repo.create(
          name: name,
          type: _type,
          currency: _currency,
          units: units,
          currentValue: value,
        );
      } else {
        await repo.update(widget.asset!.id, name: name, type: _type, units: units);
        if (value != null) {
          await repo.addValue(
            widget.asset!.id,
            amount: value,
            date: DateTime.now().toIso8601String().split('T').first,
          );
        }
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
      title: widget.asset == null ? 'New Asset' : 'Edit Asset',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Type',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final type in _kAssetTypes)
                ChoiceChip(
                  label: Text(_typeLabel(type)),
                  selected: type == _type,
                  onSelected: (_) => setState(() => _type = type),
                ),
            ],
          ),
        ),
        LabeledField(
          label: 'Name',
          child: TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'e.g. Brokerage account'),
          ),
        ),
        LabeledField(
          label: widget.asset == null ? 'Current value' : 'Update value to',
          child: TextField(
            controller: _value,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        LabeledField(
          label: 'Units (optional)',
          child: TextField(
            controller: _units,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        if (widget.asset == null)
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
      ],
    );
  }

  String _typeLabel(String type) => switch (type) {
        'cash' => 'Cash',
        'investment' => 'Investment',
        'real_estate' => 'Real estate',
        'vehicle' => 'Vehicle',
        _ => 'Other',
      };
}
