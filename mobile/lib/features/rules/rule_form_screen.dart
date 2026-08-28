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
import '../../models/payee.dart';
import '../../models/rule.dart';
import '../accounts/accounts_screen.dart';
import '../categories/categories_screen.dart';
import '../payees/payees_screen.dart';
import 'rules_screen.dart';

const _kFields = [
  'description', 'payee', 'notes', 'amount', 'type', 'account_id', 'payee_id', 'date',
];

const _kFieldLabels = {
  'description': 'Description',
  'payee': 'Raw payee text',
  'notes': 'Notes',
  'amount': 'Amount',
  'type': 'Type',
  'account_id': 'Account',
  'payee_id': 'Payee',
  'date': 'Date',
};

const _kStringOps = [
  ('contains', 'contains'),
  ('not_contains', 'does not contain'),
  ('equals', 'is'),
  ('not_equals', 'is not'),
  ('starts_with', 'starts with'),
  ('ends_with', 'ends with'),
  ('regex', 'matches regex'),
];

const _kNumericOps = [
  ('equals', '='),
  ('gt', '>'),
  ('gte', '>='),
  ('lt', '<'),
  ('lte', '<='),
];

const _kIsOps = [('equals', 'is'), ('not_equals', 'is not')];
const _kIsOnlyOp = [('equals', 'is')];

List<(String, String)> _opsForField(String field) {
  if (field == 'amount' || field == 'date') return _kNumericOps;
  if (field == 'type') return _kIsOnlyOp;
  if (field == 'account_id' || field == 'payee_id') return _kIsOps;
  return _kStringOps;
}

String _defaultValueForField(String field) => field == 'type' ? 'debit' : '';

Map<String, dynamic> _newLeaf() => {'field': 'description', 'op': 'contains', 'value': ''};

Map<String, dynamic> _newGroup() => {
      'op': 'or',
      'conditions': [_newLeaf()],
    };

bool _isGroup(Map<String, dynamic> node) => node.containsKey('conditions');

const _kActionOps = [
  ('set_category', 'Set category'),
  ('set_description', 'Set description'),
  ('set_payee', 'Set payee'),
  ('append_notes', 'Append notes'),
  ('ignore', 'Ignore transaction'),
];

Map<String, dynamic> _newAction() => {'op': 'set_category', 'value': ''};

/// The editor only ever writes string values, but a rule saved elsewhere
/// (the web editor, or an older server-side default) may carry a number or
/// bool — coerce on load so every `as String` read below is safe.
Map<String, dynamic> _normalizeLeaf(Map<String, dynamic> leaf) => {
      'field': leaf['field'],
      'op': leaf['op'],
      'value': leaf['value']?.toString() ?? '',
    };

Map<String, dynamic> _normalizeNode(Map<String, dynamic> node) {
  if (_isGroup(node)) {
    return {
      'op': node['op'],
      'conditions': [
        for (final leaf in (node['conditions'] as List).cast<Map<String, dynamic>>())
          _normalizeLeaf(leaf),
      ],
    };
  }
  return _normalizeLeaf(node);
}

Map<String, dynamic> _normalizeAction(Map<String, dynamic> action) => {
      'op': action['op'],
      'value': action['op'] == 'ignore' ? '' : (action['value']?.toString() ?? ''),
    };

class RuleFormScreen extends ConsumerStatefulWidget {
  const RuleFormScreen({this.rule, this.initialName, this.initialCondition, super.key});
  final Rule? rule;

  /// Prefill for the "create rule from this transaction" shortcut — the
  /// transaction's own description, so the new rule already has a sensible
  /// name before the user touches anything.
  final String? initialName;

  /// Same shortcut: seeds the first condition (typically field
  /// 'description', op 'contains', value the transaction's own text) so
  /// the common case — "match transactions like this one" — needs no
  /// retyping.
  final Map<String, dynamic>? initialCondition;

  @override
  ConsumerState<RuleFormScreen> createState() => _RuleFormScreenState();
}

class _RuleFormScreenState extends ConsumerState<RuleFormScreen> {
  late final _name =
      TextEditingController(text: widget.rule?.name ?? widget.initialName ?? '');
  late bool _isActive = widget.rule?.isActive ?? true;
  late String _conditionsOp = widget.rule?.conditionsOp ?? 'and';
  late final List<Map<String, dynamic>> _conditions = widget.rule != null
      ? widget.rule!.conditions.map(_normalizeNode).toList()
      : [
          widget.initialCondition != null
              ? _normalizeLeaf(widget.initialCondition!)
              : _newLeaf()
        ];
  late final List<Map<String, dynamic>> _actions = widget.rule != null
      ? widget.rule!.actions.map(_normalizeAction).toList()
      : [_newAction()];
  bool _saving = false;
  bool _loadingRefs = true;
  List<Category> _categories = [];
  List<Account> _accounts = [];
  List<Payee> _payees = [];

  @override
  void initState() {
    super.initState();
    _loadRefs();
  }

  Future<void> _loadRefs() async {
    try {
      final results = await Future.wait([
        ref.read(categoriesRepositoryProvider).list(),
        ref.read(accountsRepositoryProvider).list(),
        ref.read(payeesRepositoryProvider).list(),
      ]);
      if (!mounted) return;
      setState(() {
        _categories = results[0] as List<Category>;
        _accounts = results[1] as List<Account>;
        _payees = results[2] as List<Payee>;
        _loadingRefs = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingRefs = false);
      showAppToast(context, '$error', isError: true);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    if (_conditions.isEmpty) {
      showAppToast(context, 'Add at least one condition', isError: true);
      return;
    }
    if (_actions.isEmpty) {
      showAppToast(context, 'Add at least one action', isError: true);
      return;
    }
    for (final node in _conditions) {
      if (_isGroup(node)) {
        for (final leaf in (node['conditions'] as List).cast<Map<String, dynamic>>()) {
          if ((leaf['value'] as String).trim().isEmpty) {
            showAppToast(context, 'Fill in every condition value', isError: true);
            return;
          }
        }
      } else if ((node['value'] as String).trim().isEmpty) {
        showAppToast(context, 'Fill in every condition value', isError: true);
        return;
      }
    }
    for (final action in _actions) {
      if (action['op'] != 'ignore' && (action['value'] as String).trim().isEmpty) {
        showAppToast(context, 'Fill in every action value', isError: true);
        return;
      }
    }
    setState(() => _saving = true);
    final repo = ref.read(rulesRepositoryProvider);
    final actionsPayload = [
      for (final a in _actions)
        {'op': a['op'], 'value': a['op'] == 'ignore' ? true : a['value']},
    ];
    try {
      if (widget.rule == null) {
        await repo.create(
          name: name,
          conditionsOp: _conditionsOp,
          conditions: _conditions,
          actions: actionsPayload,
          isActive: _isActive,
        );
      } else {
        await repo.update(
          widget.rule!.id,
          name: name,
          conditionsOp: _conditionsOp,
          conditions: _conditions,
          actions: actionsPayload,
          isActive: _isActive,
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
    return FormScreen(
      title: widget.rule == null ? 'New Rule' : 'Edit Rule',
      saving: _saving,
      canSave: !_loadingRefs,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Name',
          child: TextField(
            controller: _name,
            decoration: const InputDecoration(hintText: 'e.g. Uber rides'),
          ),
        ),
        LabeledField(
          label: 'Active',
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
            title: const Text('Apply to new transactions'),
          ),
        ),
        LabeledField(
          label: 'If',
          child: Row(
            children: [
              const Text('Match '),
              _OpChip(
                value: _conditionsOp,
                onChanged: (v) => setState(() => _conditionsOp = v),
              ),
              const Text(' of the following:'),
            ],
          ),
        ),
        for (var i = 0; i < _conditions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _isGroup(_conditions[i])
                ? _GroupEditor(
                    node: _conditions[i],
                    accounts: _accounts,
                    payees: _payees,
                    onChanged: () => setState(() {}),
                    onRemove: () => setState(() => _conditions.removeAt(i)),
                  )
                : _LeafEditor(
                    leaf: _conditions[i],
                    accounts: _accounts,
                    payees: _payees,
                    onChanged: () => setState(() {}),
                    onRemove: () => setState(() => _conditions.removeAt(i)),
                  ),
          ),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => setState(() => _conditions.add(_newLeaf())),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Condition'),
            ),
            TextButton.icon(
              onPressed: () => setState(() => _conditions.add(_newGroup())),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Group'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const LabeledField(label: 'Then', child: SizedBox.shrink()),
        for (var i = 0; i < _actions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ActionEditor(
              action: _actions[i],
              categories: _categories,
              payees: _payees,
              onChanged: () => setState(() {}),
              onRemove: _actions.length > 1 ? () => setState(() => _actions.removeAt(i)) : null,
            ),
          ),
        TextButton.icon(
          onPressed: () => setState(() => _actions.add(_newAction())),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Action'),
        ),
      ],
    );
  }
}

class _OpChip extends StatelessWidget {
  const _OpChip({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact),
      segments: const [
        ButtonSegment(value: 'and', label: Text('all')),
        ButtonSegment(value: 'or', label: Text('any')),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _LeafEditor extends StatelessWidget {
  const _LeafEditor({
    required this.leaf,
    required this.accounts,
    required this.payees,
    required this.onChanged,
    required this.onRemove,
  });
  final Map<String, dynamic> leaf;
  final List<Account> accounts;
  final List<Payee> payees;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final field = leaf['field'] as String;
    final op = leaf['op'] as String;
    final ops = _opsForField(field);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: field,
                  isDense: true,
                  items: [
                    for (final f in _kFields)
                      DropdownMenuItem(value: f, child: Text(_kFieldLabels[f]!)),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    leaf['field'] = v;
                    leaf['op'] = _opsForField(v).first.$1;
                    leaf['value'] = _defaultValueForField(v);
                    onChanged();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: ops.any((o) => o.$1 == op) ? op : ops.first.$1,
                  isDense: true,
                  items: [
                    for (final o in ops) DropdownMenuItem(value: o.$1, child: Text(o.$2)),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    leaf['op'] = v;
                    onChanged();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onRemove,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 6),
          _ValueEditor(field: field, leaf: leaf, accounts: accounts, payees: payees, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ValueEditor extends StatelessWidget {
  const _ValueEditor({
    required this.field,
    required this.leaf,
    required this.accounts,
    required this.payees,
    required this.onChanged,
  });
  final String field;
  final Map<String, dynamic> leaf;
  final List<Account> accounts;
  final List<Payee> payees;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    if (field == 'type') {
      return SegmentedButton<String>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(value: 'debit', label: Text('Debit')),
          ButtonSegment(value: 'credit', label: Text('Credit')),
        ],
        selected: {(leaf['value'] as String?)?.isEmpty ?? true ? 'debit' : leaf['value'] as String},
        onSelectionChanged: (s) {
          leaf['value'] = s.first;
          onChanged();
        },
      );
    }

    if (field == 'account_id') {
      final selected = accounts.where((a) => a.id == leaf['value']).firstOrNull;
      return Pressable(
        onTap: () async {
          final picked = await showPickerSheet<Account>(
            context,
            title: 'Account',
            items: accounts,
            labelBuilder: (a) => a.label,
            selected: selected,
          );
          if (picked != null) {
            leaf['value'] = picked.id;
            onChanged();
          }
        },
        child: _valueBox(context, selected?.label ?? 'Choose an account', colors),
      );
    }

    if (field == 'payee_id') {
      final selected = payees.where((p) => p.id == leaf['value']).firstOrNull;
      return Pressable(
        onTap: () async {
          final picked = await showPickerSheet<Payee>(
            context,
            title: 'Payee',
            items: payees,
            labelBuilder: (p) => p.name,
            selected: selected,
          );
          if (picked != null) {
            leaf['value'] = picked.id;
            onChanged();
          }
        },
        child: _valueBox(context, selected?.name ?? 'Choose a payee', colors),
      );
    }

    if (field == 'date') {
      final value = leaf['value'] as String?;
      return Pressable(
        onTap: () async {
          DateTime picked = DateTime.tryParse(value ?? '') ?? DateTime.now();
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (context) => Container(
              height: 260,
              color: colors.card,
              child: Column(
                children: [
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: picked,
                      onDateTimeChanged: (v) => picked = v,
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
          leaf['value'] = DateFormat('yyyy-MM-dd').format(picked);
          onChanged();
        },
        child: _valueBox(
          context,
          value == null || value.isEmpty ? 'Choose a date' : value,
          colors,
        ),
      );
    }

    return TextField(
      controller: TextEditingController(text: leaf['value'] as String? ?? '')
        ..selection = TextSelection.collapsed(offset: (leaf['value'] as String? ?? '').length),
      keyboardType: field == 'amount' ? const TextInputType.numberWithOptions(decimal: true) : null,
      decoration: InputDecoration(
        isDense: true,
        hintText: field == 'amount' ? '0.00' : 'Value to match',
      ),
      onChanged: (v) {
        leaf['value'] = v;
      },
    );
  }

  Widget _valueBox(BuildContext context, String label, SecuroColors colors) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.input),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
          Icon(Icons.unfold_more, size: 16, color: colors.mutedForeground),
        ],
      ),
    );
  }
}

class _GroupEditor extends StatelessWidget {
  const _GroupEditor({
    required this.node,
    required this.accounts,
    required this.payees,
    required this.onChanged,
    required this.onRemove,
  });
  final Map<String, dynamic> node;
  final List<Account> accounts;
  final List<Payee> payees;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final leaves = (node['conditions'] as List).cast<Map<String, dynamic>>();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.border, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Match '),
              _OpChip(
                value: node['op'] as String,
                onChanged: (v) {
                  node['op'] = v;
                  onChanged();
                },
              ),
              const Text(' of:'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onRemove,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          for (var i = 0; i < leaves.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _LeafEditor(
                leaf: leaves[i],
                accounts: accounts,
                payees: payees,
                onChanged: onChanged,
                onRemove: () {
                  leaves.removeAt(i);
                  onChanged();
                },
              ),
            ),
          TextButton.icon(
            onPressed: () {
              leaves.add(_newLeaf());
              onChanged();
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Condition'),
          ),
        ],
      ),
    );
  }
}

class _ActionEditor extends StatelessWidget {
  const _ActionEditor({
    required this.action,
    required this.categories,
    required this.payees,
    required this.onChanged,
    this.onRemove,
  });
  final Map<String, dynamic> action;
  final List<Category> categories;
  final List<Payee> payees;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final op = action['op'] as String;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: op,
                  isDense: true,
                  items: [
                    for (final a in _kActionOps)
                      DropdownMenuItem(value: a.$1, child: Text(a.$2)),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    action['op'] = v;
                    action['value'] = '';
                    onChanged();
                  },
                ),
              ),
              if (onRemove != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onRemove,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          if (op != 'ignore') ...[
            const SizedBox(height: 6),
            if (op == 'set_category')
              Pressable(
                onTap: () async {
                  final selected = categories.where((c) => c.id == action['value']).firstOrNull;
                  final picked = await showPickerSheet<Category>(
                    context,
                    title: 'Category',
                    items: categories,
                    labelBuilder: (c) => c.name,
                    selected: selected,
                  );
                  if (picked != null) {
                    action['value'] = picked.id;
                    onChanged();
                  }
                },
                child: _box(
                  context,
                  categories.where((c) => c.id == action['value']).firstOrNull?.name ??
                      'Choose a category',
                  colors,
                ),
              )
            else if (op == 'set_payee')
              Pressable(
                onTap: () async {
                  final selected = payees.where((p) => p.id == action['value']).firstOrNull;
                  final picked = await showPickerSheet<Payee>(
                    context,
                    title: 'Payee',
                    items: payees,
                    labelBuilder: (p) => p.name,
                    selected: selected,
                  );
                  if (picked != null) {
                    action['value'] = picked.id;
                    onChanged();
                  }
                },
                child: _box(
                  context,
                  payees.where((p) => p.id == action['value']).firstOrNull?.name ??
                      'Choose a payee',
                  colors,
                ),
              )
            else
              TextField(
                controller: TextEditingController(text: action['value'] as String? ?? '')
                  ..selection =
                      TextSelection.collapsed(offset: (action['value'] as String? ?? '').length),
                maxLength: op == 'set_description' ? 500 : null,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: op == 'set_description' ? 'New description' : 'Text to append',
                  counterText: '',
                ),
                onChanged: (v) => action['value'] = v,
              ),
          ],
        ],
      ),
    );
  }

  Widget _box(BuildContext context, String label, SecuroColors colors) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.input),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
          Icon(Icons.unfold_more, size: 16, color: colors.mutedForeground),
        ],
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
