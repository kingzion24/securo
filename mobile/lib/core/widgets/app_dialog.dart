import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/tokens.dart';

/// The app's own centered dialog — replaces Material's stock `AlertDialog`
/// everywhere so every confirm/prompt in the app shares one look: a
/// dimmed scrim, a rounded card that settles in with no overshoot (a
/// dialog opening isn't gesture-driven, so it stays critically damped per
/// the Apple motion guidance — bounce is reserved for flicks/drags), a
/// negative-tracking title, and iOS-alert-style actions (a hairline row,
/// split evenly for two, stacked for more than two).
///
/// Drop-in shape for the handful of `AlertDialog` call sites this replaces:
/// `title`, `content`, `actions`. Show it with [showAppDialog] instead of
/// `showDialog`.
class AppDialog extends StatelessWidget {
  const AppDialog({required this.title, this.content, this.actions = const [], super.key});

  final String title;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: (width * 0.86).clamp(280, 360),
          constraints: const BoxConstraints(maxHeight: 520),
          decoration: BoxDecoration(
            color: colors.popover,
            borderRadius: BorderRadius.circular(SecuroRadius.xl2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.01 * 17,
                            ),
                      ),
                      if (content != null) ...[
                        const SizedBox(height: 10),
                        DefaultTextStyle.merge(
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: colors.mutedForeground),
                          textAlign: TextAlign.center,
                          child: content!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (actions.isNotEmpty) ...[
                Divider(height: 1, color: colors.border),
                _ActionsRow(actions: actions),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({required this.actions});
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    if (actions.length <= 2) {
      return IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) VerticalDivider(width: 1, color: colors.border),
              Expanded(child: actions[i]),
            ],
          ],
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) Divider(height: 1, color: colors.border),
          actions[i],
        ],
      ],
    );
  }
}

/// One row/cell inside [AppDialog]'s action bar — the iOS-alert button
/// style: plain text, no fill, destructive in red, the default action bold.
class AppDialogAction extends StatelessWidget {
  const AppDialogAction({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
    this.isDefaultAction = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefaultAction;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final color = isDestructive ? colors.destructive : colors.primary;

    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: onPressed == null ? colors.mutedForeground : color,
              fontWeight: isDefaultAction ? FontWeight.w700 : FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows [dialog] with a dimmed scrim and a settle-in-place scale+fade —
/// no overshoot, since opening a dialog isn't a gesture the user can carry
/// momentum from.
Future<T?> showAppDialog<T>(BuildContext context, {required WidgetBuilder builder}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.92, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}
