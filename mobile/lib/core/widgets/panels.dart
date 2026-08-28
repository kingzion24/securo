import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/tokens.dart';

/// A bordered surface matching the web app's `Card`: flat, hairline border,
/// no elevation or tint.
class SecuroCard extends StatelessWidget {
  const SecuroCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final content = Padding(padding: padding, child: child);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(SecuroRadius.card),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(onTap: onTap, child: content),
    );
  }
}

/// The Apple Liquid Glass "unified panel" pattern: sibling rows share one
/// rounded surface with hairline dividers between them, instead of each
/// getting its own separately-bordered card. Reach for this any time a
/// screen would otherwise stack several small `SecuroCard`s in a row —
/// that fragmentation is what reads as a generic form-builder rather than
/// an Apple-made screen.
class GroupedPanel extends StatelessWidget {
  const GroupedPanel({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(SecuroRadius.card),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: 16, color: colors.border),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// One row inside a [GroupedPanel] — the iOS Settings-cell shape: an
/// optional leading icon, a label (with an optional secondary line), and a
/// trailing widget (value text, a switch, a chevron, or nothing). `onTap`
/// makes the whole row pressable with the platform ripple; omit it for a
/// row that's just displaying a value.
class GroupedRow extends StatelessWidget {
  const GroupedRow({
    required this.label,
    this.subtitle,
    this.leadingIcon,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.destructive = false,
    super.key,
  });

  final String label;
  final String? subtitle;
  final IconData? leadingIcon;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;
    final labelColor = destructive ? colors.destructive : colors.foreground;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 19, color: iconColor ?? colors.mutedForeground),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: text.bodyMedium?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: text.bodySmall?.copyWith(color: colors.mutedForeground),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          if (onTap != null && trailing == null) ...[
            const SizedBox(width: 12),
            Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
          ],
        ],
      ),
    );

    return onTap == null
        ? content
        : InkWell(onTap: onTap, child: content);
  }
}

/// A section heading paired with its [GroupedPanel] — the vertical rhythm
/// every settings-style screen in the app should share.
class GroupedSection extends StatelessWidget {
  const GroupedSection({required this.title, required this.rows, this.footer, super.key});

  final String title;
  final List<Widget> rows;

  /// Small muted caption under the panel, iOS-settings style — used for a
  /// one-line explanation of what the section does.
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        GroupedPanel(children: rows),
        if (footer != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              footer!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.mutedForeground),
            ),
          ),
        ],
      ],
    );
  }
}

/// Section heading used above card groups.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {this.action, super.key});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ?action,
          ],
        ),
      );
}

/// Shown when a list has nothing in it yet.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: colors.mutedForeground),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: text.bodySmall?.copyWith(color: colors.mutedForeground),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

/// Shown when a panel's request failed. Always offers a retry — a transient
/// tailnet drop is the most likely cause, and it usually clears on a second
/// attempt.
class ErrorState extends StatelessWidget {
  const ErrorState({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 36, color: colors.destructive),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: colors.mutedForeground),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Placeholder block used while a panel loads.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({this.height = 16, this.width, this.radius = 6, super.key});

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: SecuroTheme.of(context).muted,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
