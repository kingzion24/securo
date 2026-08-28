import 'dart:async';

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
import '../../models/asset.dart';
import 'assets_screen.dart';

const _kAssetTypes = ['cash', 'investment', 'real_estate', 'vehicle', 'other'];
const _kGrowthTypes = [('percentage', 'Percentage'), ('absolute', 'Fixed amount')];
const _kGrowthFrequencies = [
  ('daily', 'Daily'),
  ('weekly', 'Weekly'),
  ('monthly', 'Monthly'),
  ('yearly', 'Yearly'),
];

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

  // Method: 'manual' | 'market_price' | 'growth_rule'. Immutable once
  // created — the server has no way to change how a holding is valued
  // after the fact.
  late String _method = widget.asset?.valuationMethod ?? 'manual';

  // Market ticker.
  final _tickerQuery = TextEditingController();
  Timer? _searchDebounce;
  List<MarketSymbolMatch> _searchResults = [];
  bool _searching = false;
  MarketSymbolMatch? _selectedSymbol;
  MarketSymbolQuote? _quote;
  bool _loadingQuote = false;
  late final _unitPrice = TextEditingController();

  // Growth model.
  late final _purchasePrice =
      TextEditingController(text: widget.asset?.purchasePrice?.toString() ?? '');
  late DateTime _purchaseDate =
      DateTime.tryParse(widget.asset?.purchaseDate ?? '') ?? DateTime.now();
  late String _growthType = widget.asset?.growthType ?? 'percentage';
  late final _growthRate =
      TextEditingController(text: widget.asset?.growthRate?.toString() ?? '');
  late String _growthFrequency = widget.asset?.growthFrequency ?? 'monthly';
  late DateTime? _growthStartDate =
      DateTime.tryParse(widget.asset?.growthStartDate ?? '');

  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _value.dispose();
    _units.dispose();
    _tickerQuery.dispose();
    _unitPrice.dispose();
    _purchasePrice.dispose();
    _growthRate.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onTickerChanged(String query) {
    _searchDebounce?.cancel();
    if (query.trim().length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      setState(() => _searching = true);
      try {
        final results = await ref.read(assetsRepositoryProvider).marketSearch(query.trim());
        if (!mounted) return;
        setState(() {
          _searchResults = results;
          _searching = false;
        });
      } catch (error) {
        if (!mounted) return;
        setState(() => _searching = false);
      }
    });
  }

  Future<void> _selectSymbol(MarketSymbolMatch match) async {
    setState(() {
      _selectedSymbol = match;
      _searchResults = [];
      _tickerQuery.text = match.symbol;
      _loadingQuote = true;
    });
    try {
      final quote = await ref.read(assetsRepositoryProvider).marketQuote(match.symbol);
      if (!mounted) return;
      setState(() {
        _quote = quote;
        _loadingQuote = false;
        if (_name.text.trim().isEmpty) _name.text = quote.name ?? match.symbol;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingQuote = false);
      showAppToast(context, '$error', isError: true);
    }
  }

  Future<DateTime?> _pickDate(DateTime initial, {DateTime? maximumDate}) async {
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
                maximumDate: maximumDate,
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
    return picked;
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    if (_method == 'market_price' && widget.asset == null) {
      if (_selectedSymbol == null) {
        showAppToast(context, 'Search for and select a ticker', isError: true);
        return;
      }
      final units = double.tryParse(_units.text.trim());
      if (units == null || units <= 0) {
        showAppToast(context, 'Enter how many units you hold', isError: true);
        return;
      }
    }
    if (_method == 'growth_rule') {
      final price = double.tryParse(_purchasePrice.text.trim());
      final rate = double.tryParse(_growthRate.text.trim());
      if (price == null || price <= 0) {
        showAppToast(context, 'Enter the purchase price', isError: true);
        return;
      }
      if (rate == null) {
        showAppToast(context, 'Enter a growth rate', isError: true);
        return;
      }
    }

    setState(() => _saving = true);
    final repo = ref.read(assetsRepositoryProvider);
    final value = double.tryParse(_value.text.trim());
    final units = _units.text.trim().isEmpty ? null : double.tryParse(_units.text.trim());
    try {
      if (widget.asset == null) {
        await repo.create(
          name: name,
          type: _type,
          currency: _method == 'market_price' ? (_quote?.currency ?? _currency) : _currency,
          valuationMethod: _method,
          units: _method == 'market_price' ? units : units,
          currentValue: _method == 'manual' ? value : null,
          ticker: _method == 'market_price' ? _selectedSymbol?.symbol : null,
          tickerExchange: _method == 'market_price' ? _selectedSymbol?.exchange : null,
          unitPrice: _method == 'market_price' && _unitPrice.text.trim().isNotEmpty
              ? double.tryParse(_unitPrice.text.trim())
              : null,
          purchaseDate: _method == 'growth_rule'
              ? DateFormat('yyyy-MM-dd').format(_purchaseDate)
              : null,
          purchasePrice:
              _method == 'growth_rule' ? double.tryParse(_purchasePrice.text.trim()) : null,
          growthType: _method == 'growth_rule' ? _growthType : null,
          growthRate:
              _method == 'growth_rule' ? double.tryParse(_growthRate.text.trim()) : null,
          growthFrequency: _method == 'growth_rule' ? _growthFrequency : null,
          growthStartDate: _method == 'growth_rule' && _growthStartDate != null
              ? DateFormat('yyyy-MM-dd').format(_growthStartDate!)
              : null,
        );
      } else {
        await repo.update(
          widget.asset!.id,
          name: name,
          type: _type,
          units: _method == 'manual' ? units : null,
          purchasePrice:
              _method == 'growth_rule' ? double.tryParse(_purchasePrice.text.trim()) : null,
          purchaseDate:
              _method == 'growth_rule' ? DateFormat('yyyy-MM-dd').format(_purchaseDate) : null,
          growthType: _method == 'growth_rule' ? _growthType : null,
          growthRate:
              _method == 'growth_rule' ? double.tryParse(_growthRate.text.trim()) : null,
          growthFrequency: _method == 'growth_rule' ? _growthFrequency : null,
          growthStartDate: _method == 'growth_rule' && _growthStartDate != null
              ? DateFormat('yyyy-MM-dd').format(_growthStartDate!)
              : null,
        );
        if (_method == 'manual' && value != null) {
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
    final editingExisting = widget.asset != null;

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
        if (!editingExisting)
          LabeledField(
            label: 'Valuation method',
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'manual', label: Text('Manual')),
                ButtonSegment(value: 'market_price', label: Text('Ticker')),
                ButtonSegment(value: 'growth_rule', label: Text('Growth model')),
              ],
              selected: {_method},
              onSelectionChanged: (s) => setState(() => _method = s.first),
            ),
          )
        else if (_method != 'manual')
          LabeledField(
            label: 'Valuation method',
            child: Text(
              _method == 'market_price' ? 'Ticker-priced' : 'Growth model',
              style: TextStyle(color: colors.mutedForeground),
            ),
          ),
        if (_method == 'manual') ...[
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
        ],
        if (_method == 'market_price' && !editingExisting) ...[
          LabeledField(
            label: 'Ticker',
            child: TextField(
              controller: _tickerQuery,
              textCapitalization: TextCapitalization.characters,
              onChanged: _onTickerChanged,
              decoration: InputDecoration(
                hintText: 'e.g. AAPL',
                suffixIcon: _searching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          if (_searchResults.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(SecuroRadius.md),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  for (final match in _searchResults)
                    Pressable(
                      onTap: () => _selectSymbol(match),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(match.symbol,
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                  if (match.name != null)
                                    Text(match.name!,
                                        style: TextStyle(color: colors.mutedForeground)),
                                ],
                              ),
                            ),
                            if (match.exchange != null)
                              Text(match.exchange!,
                                  style: TextStyle(color: colors.mutedForeground)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (_selectedSymbol != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _loadingQuote
                    ? 'Fetching quote…'
                    : _quote == null
                        ? 'No live quote available'
                        : '${_quote!.currency} ${_quote!.price.toStringAsFixed(2)} · ${_quote!.name ?? _selectedSymbol!.symbol}',
                style: TextStyle(color: colors.mutedForeground),
              ),
            ),
          LabeledField(
            label: 'Units held',
            child: TextField(
              controller: _units,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          LabeledField(
            label: 'Price paid per unit (optional)',
            child: TextField(
              controller: _unitPrice,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: 'Defaults to the live price'),
            ),
          ),
        ] else if (_method == 'market_price' && editingExisting)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${widget.asset!.ticker ?? ''} · last price '
              '${widget.asset!.lastPrice?.toStringAsFixed(2) ?? '—'} ${widget.asset!.currency}. '
              'Record a buy or sell from the asset list to change units.',
              style: TextStyle(color: colors.mutedForeground),
            ),
          ),
        if (_method == 'growth_rule') ...[
          LabeledField(
            label: 'Purchase price',
            child: TextField(
              controller: _purchasePrice,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          LabeledField(
            label: 'Purchase date',
            child: Pressable(
              onTap: () async {
                final picked = await _pickDate(_purchaseDate, maximumDate: DateTime.now());
                if (picked != null) setState(() => _purchaseDate = picked);
              },
              child: _dateBox(context, DateFormat.yMMMd().format(_purchaseDate), colors),
            ),
          ),
          LabeledField(
            label: 'Growth type',
            child: SegmentedButton<String>(
              segments: [
                for (final g in _kGrowthTypes) ButtonSegment(value: g.$1, label: Text(g.$2)),
              ],
              selected: {_growthType},
              onSelectionChanged: (s) => setState(() => _growthType = s.first),
            ),
          ),
          LabeledField(
            label: _growthType == 'percentage' ? 'Growth rate (%)' : 'Growth amount',
            child: TextField(
              controller: _growthRate,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            ),
          ),
          LabeledField(
            label: 'Growth frequency',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final f in _kGrowthFrequencies)
                  ChoiceChip(
                    label: Text(f.$2),
                    selected: f.$1 == _growthFrequency,
                    onSelected: (_) => setState(() => _growthFrequency = f.$1),
                  ),
              ],
            ),
          ),
          LabeledField(
            label: 'Growth starts (optional)',
            child: Pressable(
              onTap: () async {
                final picked = await _pickDate(_growthStartDate ?? _purchaseDate);
                if (picked != null) setState(() => _growthStartDate = picked);
              },
              child: _dateBox(
                context,
                _growthStartDate == null
                    ? 'Same as purchase date'
                    : DateFormat.yMMMd().format(_growthStartDate!),
                colors,
              ),
            ),
          ),
        ],
        if (!editingExisting && _method != 'market_price')
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
              child: _dateBox(context, _currency, colors),
            ),
          ),
      ],
    );
  }

  Widget _dateBox(BuildContext context, String label, SecuroColors colors) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.input),
      ),
      child: Row(children: [Expanded(child: Text(label))]),
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
