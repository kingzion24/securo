import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme.dart';
import '../auth/auth_controller.dart';
import '../workspace/workspace_controller.dart';
import 'idle_lock.dart';
import 'nav_drawer.dart';

/// Chrome around every signed-in screen: the bottom tab bar, the overflow
/// drawer holding the rest of the web sidebar, and the idle-lock watcher.
class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  /// The four destinations that earn a permanent tab on a phone. Everything
  /// else in the web sidebar lives in the drawer.
  static const _tabs = [
    (path: '/', label: 'Home', icon: Icons.home_outlined, selected: Icons.home),
    (
      path: '/transactions',
      label: 'Transactions',
      icon: Icons.swap_horiz,
      selected: Icons.swap_horiz
    ),
    (
      path: '/accounts',
      label: 'Accounts',
      icon: Icons.account_balance_outlined,
      selected: Icons.account_balance
    ),
    (
      path: '/reports',
      label: 'Reports',
      icon: Icons.bar_chart_outlined,
      selected: Icons.bar_chart
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = SecuroTheme.of(context);
    final location = GoRouterState.of(context).matchedLocation;
    final workspace = ref.watch(currentWorkspaceProvider).valueOrNull;

    // A tab whose module the workspace has switched off should not be shown.
    final tabs = _tabs.where((tab) {
      if (workspace == null) return true;
      return switch (tab.path) {
        '/transactions' => workspace.hasModule('transactions'),
        '/accounts' => workspace.hasModule('accounts'),
        '/reports' => workspace.hasModule('reports'),
        _ => true,
      };
    }).toList();

    final index = tabs.indexWhere((t) => t.path == location);

    return IdleLock(
      idleMinutes: ref
          .watch(authControllerProvider)
          .user
          ?.preferences
          .idleLockMinutesOrDefault,
      onIdle: () => ref.read(authControllerProvider.notifier).lock(),
      child: Scaffold(
        backgroundColor: colors.background,
        drawer: const AppNavDrawer(),
        body: child,
        extendBody: true,
        // A translucent bar with content scrolling under it, not an opaque
        // strip that permanently claims the bottom of the screen — the
        // floating-chrome-over-content material Apple uses for nav bars.
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.card.withValues(alpha: 0.72),
                border: Border(
                  top: BorderSide(color: colors.border.withValues(alpha: 0.6)),
                ),
              ),
              child: NavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                // -1 while on a drawer-only screen; NavigationBar needs a
                // valid index, and highlighting nothing is the honest state
                // there.
                selectedIndex: index < 0 ? 0 : index,
                onDestinationSelected: (i) => context.go(tabs[i].path),
                destinations: [
                  for (final tab in tabs)
                    NavigationDestination(
                      icon: Icon(tab.icon),
                      selectedIcon: Icon(tab.selected),
                      label: tab.label,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
