import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/color.dart';
import '../../core/icons/lucide_icon_map.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/category.dart';
import 'categories_screen.dart';

/// The swatch every color picker in the app offers — the same fixed set
/// `frontend`'s category/group color pickers use isn't centrally named on
/// the web either, so this mirrors the chart palette plus a few neutrals
/// rather than inventing an unbounded color wheel.
const List<String> kColorSwatch = [
  '#EF4444', '#F97316', '#F59E0B', '#EAB308', '#84CC16',
  '#22C55E', '#10B981', '#14B8A6', '#06B6D4', '#0EA5E9',
  '#3B82F6', '#6366F1', '#8B5CF6', '#A855F7', '#D946EF',
  '#EC4899', '#F43F5E', '#6B7280',
];

/// Create (category == null) or edit (category != null) a category.
class CategoryFormScreen extends ConsumerStatefulWidget {
  const CategoryFormScreen({this.category, super.key});
  final Category? category;

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  late final _nameController =
      TextEditingController(text: widget.category?.name ?? '');
  late String _icon = widget.category?.icon.isNotEmpty == true
      ? widget.category!.icon
      : categoryIconNames.first;
  late String _color =
      widget.category?.color.isNotEmpty == true ? widget.category!.color : kColorSwatch[11];
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(categoriesRepositoryProvider);
    try {
      if (widget.category == null) {
        await repo.create(name: name, icon: _icon, color: _color);
      } else {
        await repo.update(widget.category!.id, name: name, icon: _icon, color: _color);
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
    final selectedColor = parseHexColor(_color) ?? colors.chart2;

    return FormScreen(
      title: widget.category == null ? 'New Category' : 'Edit Category',
      saving: _saving,
      onSave: _save,
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: selectedColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(SecuroRadius.card),
            ),
            alignment: Alignment.center,
            child: Icon(lucideIcon(_icon), size: 30, color: selectedColor),
          ),
        ),
        LabeledField(
          label: 'Name',
          child: TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'e.g. Groceries'),
          ),
        ),
        LabeledField(
          label: 'Color',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final hex in kColorSwatch)
                Pressable(
                  onTap: () => setState(() => _color = hex),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: parseHexColor(hex),
                      shape: BoxShape.circle,
                      border: hex == _color
                          ? Border.all(color: colors.foreground, width: 2)
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
        LabeledField(
          label: 'Icon',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final name in categoryIconNames)
                Pressable(
                  onTap: () => setState(() => _icon = name),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: name == _icon
                          ? selectedColor.withValues(alpha: 0.15)
                          : colors.muted,
                      borderRadius: BorderRadius.circular(SecuroRadius.sm),
                      border: name == _icon
                          ? Border.all(color: selectedColor)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      lucideIcon(name),
                      size: 18,
                      color: name == _icon ? selectedColor : colors.mutedForeground,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
