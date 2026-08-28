import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/color.dart';
import '../../core/icons/lucide_icon_map.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/budget.dart';
import '../../models/category.dart';
import '../categories/categories_screen.dart';
import 'budgets_screen.dart';

/// Sets this month's budget amount for a category. `budget == null` opens
/// with no category chosen (pick one, then set an amount); a non-null
/// [budget] pre-fills both, since setting again for the same category just
/// overwrites the amount.
class BudgetFormScreen extends ConsumerStatefulWidget {
  const BudgetFormScreen({this.budget, super.key});
  final BudgetVsActual? budget;

  @override
  ConsumerState<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends ConsumerState<BudgetFormScreen> {
  late final _amount =
      TextEditingController(text: widget.budget?.budgetAmount?.toString() ?? '');
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
      setState(() {
        _categories = categories;
        if (widget.budget != null) {
          _category = categories
              .where((c) => c.id == widget.budget!.categoryId)
              .firstOrNull;
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
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_category == null) {
      showAppToast(context, 'Choose a category', isError: true);
      return;
    }
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) {
      showAppToast(context, 'Enter a valid amount', isError: true);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(budgetsRepositoryProvider).setForCurrentMonth(
            categoryId: _category!.id,
            amount: amount,
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

    return FormScreen(
      title: widget.budget == null ? 'New Budget' : 'Edit Budget',
      saving: _saving,
      canSave: !_loadingCategories,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Category',
          child: Pressable(
            onTap: widget.budget != null || _loadingCategories
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
                  if (_category != null) ...[
                    Icon(
                      lucideIcon(_category!.icon),
                      size: 16,
                      color: parseHexColor(_category!.color) ?? colors.chart2,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      _category?.name ?? 'Choose a category',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _category == null ? colors.mutedForeground : null,
                          ),
                    ),
                  ),
                  if (widget.budget == null)
                    Icon(Icons.unfold_more, size: 18, color: colors.mutedForeground),
                ],
              ),
            ),
          ),
        ),
        LabeledField(
          label: 'Monthly amount',
          child: TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: '0.00'),
          ),
        ),
      ],
    );
  }
}
