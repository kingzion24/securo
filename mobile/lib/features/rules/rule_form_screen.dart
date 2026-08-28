import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/category.dart';
import '../../models/rule.dart';
import '../categories/categories_screen.dart';
import 'rules_screen.dart';

const _kFields = ['description', 'payee', 'notes'];
const _kOps = ['contains', 'equals', 'starts_with', 'ends_with'];

/// Scoped to one condition + a "set category" action — see the repository
/// doc for why. Editing a rule created on the web with a richer shape than
/// this still works (name/active toggle save independently), but its
/// condition/action are replaced wholesale if the condition fields are
/// touched here.
class RuleFormScreen extends ConsumerStatefulWidget {
  const RuleFormScreen({this.rule, super.key});
  final Rule? rule;

  @override
  ConsumerState<RuleFormScreen> createState() => _RuleFormScreenState();
}

class _RuleFormScreenState extends ConsumerState<RuleFormScreen> {
  late final _name = TextEditingController(text: widget.rule?.name ?? '');
  late final _value = TextEditingController(
    text: widget.rule?.conditions.firstOrNull?['value']?.toString() ?? '',
  );
  late String _field = widget.rule?.conditions.firstOrNull?['field'] as String? ?? 'description';
  late String _op = widget.rule?.conditions.firstOrNull?['op'] as String? ?? 'contains';
  late bool _isActive = widget.rule?.isActive ?? true;
  bool _saving = false;
  bool _loadingCategories = true;
  List<Category> _categories = [];
  Category? _category;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ref.read(categoriesRepositoryProvider).list();
      if (!mounted) return;
      final existingCategoryId = widget.rule?.actions
          .where((a) => a['op'] == 'set_category')
          .map((a) => a['value'] as String?)
          .firstOrNull;
      setState(() {
        _categories = categories;
        if (existingCategoryId != null) {
          _category = categories.where((c) => c.id == existingCategoryId).firstOrNull;
        }
        _loadingCategories = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingCategories = false);
      showAppToast(context, '$error', isError: true);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _value.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final value = _value.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    if (value.isEmpty) {
      showAppToast(context, 'Enter a value to match', isError: true);
      return;
    }
    if (_category == null) {
      showAppToast(context, 'Choose a category', isError: true);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(rulesRepositoryProvider);
    try {
      if (widget.rule == null) {
        await repo.create(
          name: name,
          field: _field,
          op: _op,
          value: value,
          categoryId: _category!.id,
          isActive: _isActive,
        );
      } else {
        await repo.update(
          widget.rule!.id,
          name: name,
          field: _field,
          op: _op,
          value: value,
          categoryId: _category!.id,
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
    final colors = SecuroTheme.of(context);

    return FormScreen(
      title: widget.rule == null ? 'New Rule' : 'Edit Rule',
      saving: _saving,
      canSave: !_loadingCategories,
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
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _field,
                  items: [
                    for (final f in _kFields)
                      DropdownMenuItem(value: f, child: Text(_fieldLabel(f))),
                  ],
                  onChanged: (v) => setState(() => _field = v!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _op,
                  items: [
                    for (final o in _kOps)
                      DropdownMenuItem(value: o, child: Text(_opLabel(o))),
                  ],
                  onChanged: (v) => setState(() => _op = v!),
                ),
              ),
            ],
          ),
        ),
        LabeledField(
          label: 'Value',
          child: TextField(
            controller: _value,
            decoration: const InputDecoration(hintText: 'e.g. UBER'),
          ),
        ),
        LabeledField(
          label: 'Set category to',
          child: Pressable(
            onTap: _loadingCategories
                ? null
                : () async {
                    final picked = await showPickerSheet<Category>(
                      context,
                      title: 'Category',
                      items: _categories,
                      labelBuilder: (c) => c.name,
                      selected: _category,
                    );
                    if (picked != null) setState(() => _category = picked);
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
                  Expanded(
                    child: Text(
                      _category?.name ?? 'Choose a category',
                      style: TextStyle(
                        color: _category == null ? colors.mutedForeground : null,
                      ),
                    ),
                  ),
                  Icon(Icons.unfold_more, size: 18, color: colors.mutedForeground),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _fieldLabel(String f) => switch (f) {
        'description' => 'Description',
        'payee' => 'Payee',
        _ => 'Notes',
      };

  String _opLabel(String o) => switch (o) {
        'contains' => 'contains',
        'equals' => 'is',
        'starts_with' => 'starts with',
        _ => 'ends with',
      };
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
