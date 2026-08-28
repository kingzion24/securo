import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

/// A tappable surface that scales down the instant a finger touches it, not
/// on release — the response Apple's fluid-interfaces guidance calls the
/// foundation everything else is built on.
///
/// The scale is driven by a genuine physics [SpringSimulation] — critically
/// damped (`bounce: 0`), not a fixed-duration tween approximating one — so it
/// is truly interruptible: a fast double-tap or a press-drag-off-and-back
/// re-targets from whatever the animation's *current* value and velocity are,
/// with no visible jump or "brick wall" where the old motion cuts off.
class Pressable extends StatefulWidget {
  const Pressable({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.pressedScale = 0.97,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final double pressedScale;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Apple's own default for a UI move: no overshoot, ~0.3s response.
  static final _spring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 300),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, lowerBound: 0, upperBound: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _reduceMotion =>
      SchedulerBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;

  void _setPressed(bool pressed) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    if (_reduceMotion) {
      _controller.value = pressed ? 1 : 0;
      return;
    }
    // animateWith starts from the controller's current value and velocity,
    // which is what makes a mid-flight reversal continuous instead of
    // snapping to a new tween's start point.
    _controller.animateWith(
      SpringSimulation(_spring, _controller.value, pressed ? 1 : 0, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 - (_controller.value * (1 - widget.pressedScale));
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
