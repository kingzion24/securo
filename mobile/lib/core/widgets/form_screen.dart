import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The iOS presented-form chrome: a plain (non-large) nav bar with Cancel on
/// the left and Save on the right, title centered — the same pattern Mail's
/// compose sheet and Calendar's new-event screen use. Deliberately distinct
/// from `LargeTitleScrollView`: a large title belongs to a root tab/drawer
/// screen, not a modal form pushed on top of one.
///
/// Push with `Navigator.of(context).push(CupertinoPageRoute(fullscreenDialog:
/// true, builder: (_) => FormScreen(...)))` so it gets the iOS
/// slide-up-from-bottom modal transition.
class FormScreen extends StatelessWidget {
  const FormScreen({
    required this.title,
    required this.children,
    required this.onSave,
    this.saving = false,
    this.saveLabel = 'Save',
    this.canSave = true,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final Future<void> Function() onSave;
  final bool saving;
  final String saveLabel;
  final bool canSave;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(title),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: colors.primary, fontSize: 16),
          ),
        ),
        actions: [
          CupertinoButton(
            padding: const EdgeInsets.only(right: 4),
            onPressed: !canSave || saving ? null : onSave,
            child: saving
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  )
                : Text(
                    saveLabel,
                    style: TextStyle(
                      color: canSave ? colors.primary : colors.mutedForeground,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: children,
        ),
      ),
    );
  }
}

/// Pushes [screen] with the iOS modal-form transition (slide up from the
/// bottom, distinct from the push-from-the-side used for drill-in
/// navigation).
Future<T?> pushFormScreen<T>(BuildContext context, Widget screen) {
  return Navigator.of(context).push<T>(
    CupertinoPageRoute(fullscreenDialog: true, builder: (_) => screen),
  );
}

/// A labeled field group — the label above the input, spaced consistently.
/// Every form in the app is built from a column of these.
class LabeledField extends StatelessWidget {
  const LabeledField({required this.label, required this.child, super.key});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
