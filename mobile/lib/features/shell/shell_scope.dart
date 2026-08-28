import 'package:flutter/material.dart';

/// Hands every screen under [AppShell] a way to open its drawer.
///
/// Each tab/drawer destination is its own top-level route with its own
/// `Scaffold` (for its own app bar, its own body), nested *inside*
/// `AppShell`'s `Scaffold`, which is the one actually holding the `Drawer`.
/// `Scaffold.of(context).openDrawer()` only ever finds the nearest
/// `Scaffold`, so a screen has no way to reach the one above it without this
/// — without it, the drawer was only reachable by an edge-swipe gesture,
/// which on Android collides with the system back gesture and silently
/// opens the previous app instead.
class ShellScope extends InheritedWidget {
  const ShellScope({required this.scaffoldKey, required super.child, super.key});

  final GlobalKey<ScaffoldState> scaffoldKey;

  static ShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellScope>();

  @override
  bool updateShouldNotify(ShellScope oldWidget) =>
      scaffoldKey != oldWidget.scaffoldKey;
}
