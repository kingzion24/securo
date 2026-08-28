import 'dart:async';

import 'package:flutter/material.dart';

/// Locks the app after a stretch of no interaction.
///
/// Mirrors the web app's idle-timeout lock screen: the timeout comes from the
/// user's `idle_lock_minutes` preference, and 0 disables it.
class IdleLock extends StatefulWidget {
  const IdleLock({
    required this.child,
    required this.onIdle,
    this.idleMinutes,
    super.key,
  });

  final Widget child;
  final VoidCallback onIdle;
  final int? idleMinutes;

  @override
  State<IdleLock> createState() => _IdleLockState();
}

class _IdleLockState extends State<IdleLock> with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restart();
  }

  @override
  void didUpdateWidget(IdleLock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.idleMinutes != widget.idleMinutes) _restart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Time spent backgrounded counts as idle time, so the timer keeps running
    // and a long absence comes back to a locked app.
    if (state == AppLifecycleState.resumed) _restart();
  }

  void _restart() {
    _timer?.cancel();
    final minutes = widget.idleMinutes ?? 0;
    if (minutes <= 0) return;
    _timer = Timer(Duration(minutes: minutes), widget.onIdle);
  }

  @override
  Widget build(BuildContext context) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _restart(),
        child: widget.child,
      );
}
