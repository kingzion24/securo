import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// An app bar built as a floating translucent material rather than an opaque
/// strip — content scrolls underneath and shows through the blur, which is
/// what makes it read as a layer of glass rather than a fixed toolbar. Pair
/// with `Scaffold(extendBodyBehindAppBar: true)` and top padding of
/// `kToolbarHeight + MediaQuery.of(context).padding.top` on the scrolling
/// content.
class TranslucentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TranslucentAppBar({
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
    super.key,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: AppBar(
          title: Text(title),
          actions: actions,
          leading: leading,
          bottom: bottom,
          backgroundColor: colors.background.withValues(alpha: 0.72),
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    );
  }
}
