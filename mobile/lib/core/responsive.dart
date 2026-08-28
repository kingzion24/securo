import 'package:flutter/material.dart';

/// Sizing helpers so a screen drawn for a mid-size phone doesn't clip, run
/// out of tap-target room, or drown in whitespace on a small or a very tall
/// device. Everything here is portrait-first — a finance tracker is a
/// one-hand, one-column app; this is not a breakpoint system for a
/// multi-column tablet/desktop layout.
///
/// Reach for [context.responsive] once per `build()`, then read off it —
/// cheaper than calling `MediaQuery.sizeOf` repeatedly and keeps every
/// clamp/scale call using the same measured width.
class Responsive {
  const Responsive._(this.width, this.height, this.textScale, this.safePadding);

  factory Responsive.of(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Responsive._(
      mq.size.width,
      mq.size.height,
      // Dynamic Type support (§15 of the Apple design skill): the layout
      // scales with the user's chosen text size rather than fighting it.
      // Clamped so a 200% accessibility setting doesn't blow the layout
      // apart — components still need to fit on screen.
      mq.textScaler.scale(1).clamp(0.9, 1.35),
      mq.padding,
    );
  }

  final double width;
  final double height;
  final double textScale;
  final EdgeInsets safePadding;

  /// Below this width (iPhone SE / mini class), tighten padding and type.
  static const double compactWidth = 375;

  /// Above this width, a phone is in landscape or is a large-screen device
  /// this app doesn't specifically design for; layouts should still not
  /// break, but this file stays portrait-first per the class doc.
  static const double regularWidth = 430;

  bool get isCompact => width < compactWidth;
  bool get isRegular => width >= compactWidth && width <= regularWidth;
  bool get isWide => width > regularWidth;

  /// Screen-edge horizontal padding: tighter on a small phone, roomier on
  /// a large one, so content never feels cramped against the bezel or
  /// lost in excess margin.
  double get pagePadding => scale(16, min: 12, max: 22);

  /// Vertical gap between stacked sections.
  double get sectionGap => scale(24, min: 18, max: 32);

  /// Scales a design value by device width relative to a 390pt baseline
  /// (iPhone 14/15/16's logical width — the size most of this app's
  /// spacing was tuned against), then clamps to a sane range so a very
  /// small or very large phone never goes absurd in either direction.
  double scale(double value, {double? min, double? max}) {
    final scaled = value * (width / 390).clamp(0.85, 1.25);
    if (min != null && scaled < min) return min;
    if (max != null && scaled > max) return max;
    return scaled;
  }

  /// A tap target that never drops below Apple's 44pt minimum, but grows a
  /// little on a bigger screen so buttons don't look stranded.
  double tapTarget({double base = 44}) => scale(base, min: 44, max: base + 8);
}

extension ResponsiveContext on BuildContext {
  Responsive get responsive => Responsive.of(this);

  /// True when the device is short enough (a compact-height phone, or any
  /// phone rotated to landscape) that a bottom sheet's default sizing
  /// should shrink to leave room for the keyboard/nav chrome.
  bool get isShortViewport => MediaQuery.sizeOf(this).height < 700;
}
