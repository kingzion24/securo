import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A brief confirmation or error toast — the equivalent of the web app's
/// `sonner` toasts. Reuses the theme's `snackBarTheme`, so no new colors to
/// keep in sync.
void showAppToast(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final colors = SecuroTheme.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              size: 18,
              color: isError ? colors.destructive : colors.background,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}

/// The iOS destructive-confirm pattern — an action sheet with a red
/// destructive option, not a centered alert dialog. Returns true if the user
/// confirmed.
Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(title),
      message: message == null ? null : Text(message),
      actions: [
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Cancel'),
      ),
    ),
  );
  return result ?? false;
}

/// A bottom-sheet single-select picker — the mobile equivalent of the web
/// app's `<Select>` dropdown for choosing a category/payee/account/etc.
/// inside a form. `null` in [items] renders as "None" and clears the
/// selection.
Future<T?> showPickerSheet<T>(
  BuildContext context, {
  required String title,
  required List<T> items,
  required String Function(T item) labelBuilder,
  T? selected,
  bool allowNone = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final colors = SecuroTheme.of(context);
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 38,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    if (allowNone)
                      _PickerRow<T?>(
                        label: 'None',
                        selected: selected == null,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    for (final item in items)
                      _PickerRow<T>(
                        label: labelBuilder(item),
                        selected: item == selected,
                        onTap: () => Navigator.of(context).pop(item),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _PickerRow<T> extends StatelessWidget {
  const _PickerRow({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return ListTile(
      title: Text(label),
      trailing: selected ? Icon(Icons.check, color: colors.primary) : null,
      onTap: onTap,
    );
  }
}
