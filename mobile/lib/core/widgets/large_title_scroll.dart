import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/shell/shell_scope.dart';
import '../theme/theme.dart';

/// The real iOS large-title nav bar — `CupertinoSliverNavigationBar`, the
/// same widget UIKit apps get, not a hand-rolled approximation. The title
/// sits big below the status bar at rest and collapses into a small
/// centered glass bar as the content scrolls under it, with
/// `CupertinoSliverRefreshControl` giving the matching iOS pull-to-refresh
/// spinner in place of Material's circular one.
///
/// Every screen under `AppShell` supplies its own `slivers` (a
/// `SliverList`/`SliverPadding`/etc. — this widget only owns the chrome
/// around them, exactly like `TranslucentAppBar` did before, just as a real
/// large title instead of a fixed-height bar).
class LargeTitleScrollView extends StatelessWidget {
  const LargeTitleScrollView({
    required this.title,
    required this.slivers,
    this.actions,
    this.controller,
    this.onRefresh,
    super.key,
  });

  final String title;
  final List<Widget> slivers;
  final List<Widget>? actions;
  final ScrollController? controller;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final shell = ShellScope.maybeOf(context);
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        controller: controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              title,
              style: TextStyle(
                color: colors.foreground,
                fontWeight: FontWeight.w700,
                fontSize: 34,
                letterSpacing: -0.02 * 34,
              ),
            ),
            middle: Text(
              title,
              style: TextStyle(
                color: colors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: colors.background.withValues(alpha: 0.72),
            border: Border(bottom: BorderSide(color: colors.border)),
            brightness: brightness,
            automaticallyImplyLeading: false,
            transitionBetweenRoutes: false,
            stretch: true,
            // A screen inside AppShell opens the drawer; one pushed on top
            // (Settings, from the drawer's own footer) gets a real back
            // chevron instead — never neither.
            leading: shell != null
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => shell.scaffoldKey.currentState?.openDrawer(),
                    child: Icon(CupertinoIcons.line_horizontal_3,
                        color: colors.foreground),
                  )
                : Navigator.of(context).canPop()
                    ? CupertinoNavigationBarBackButton(
                        color: colors.foreground,
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    : null,
            trailing: actions == null || actions!.isEmpty
                ? null
                : Row(mainAxisSize: MainAxisSize.min, children: actions!),
          ),
          if (onRefresh != null)
            CupertinoSliverRefreshControl(onRefresh: onRefresh),
          ...slivers,
        ],
      ),
    );
  }
}
