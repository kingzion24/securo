import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../auth/auth_controller.dart';
import 'idle_lock.dart';
import 'nav_drawer.dart';
import 'shell_scope.dart';

/// Chrome around every signed-in screen: the drawer holding the full web
/// sidebar, and the idle-lock watcher. Navigation is drawer-only — no
/// bottom tab bar, so every screen's vertical space belongs to its content.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return IdleLock(
      idleMinutes: ref
          .watch(authControllerProvider)
          .user
          ?.preferences
          .idleLockMinutesOrDefault,
      onIdle: () => ref.read(authControllerProvider.notifier).lock(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: colors.background,
        drawer: const AppNavDrawer(),
        body: ShellScope(scaffoldKey: _scaffoldKey, child: widget.child),
      ),
    );
  }
}
