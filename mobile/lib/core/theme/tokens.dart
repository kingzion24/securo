import 'package:flutter/material.dart';

/// Colour tokens ported 1:1 from the web app's `frontend/src/index.css`.
///
/// The two palettes below mirror the `:root` and `.dark` blocks there. Keeping
/// the names identical to the CSS custom properties is deliberate: when a token
/// changes on the web side, the corresponding line here is obvious.
class SecuroColors {
  const SecuroColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarMuted,
  });

  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarAccentForeground;
  final Color sidebarBorder;
  final Color sidebarMuted;

  List<Color> get chartPalette => [chart1, chart2, chart3, chart4, chart5];

  static const light = SecuroColors(
    background: Color(0xFFF8F9FB),
    foreground: Color(0xFF0F172A),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF0F172A),
    popover: Color(0xFFFFFFFF),
    popoverForeground: Color(0xFF0F172A),
    primary: Color(0xFF6366F1),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFF1F5F9),
    secondaryForeground: Color(0xFF0F172A),
    muted: Color(0xFFF1F5F9),
    mutedForeground: Color(0xFF64748B),
    accent: Color(0xFFEEF2FF),
    accentForeground: Color(0xFF4F46E5),
    destructive: Color(0xFFF43F5E),
    destructiveForeground: Color(0xFFFFFFFF),
    // A hairline, not a stroke: Apple's dividers and card outlines are a
    // near-black wash at low alpha over the surface, not a flat opaque grey —
    // it reads as a seam in the material rather than a drawn line.
    border: Color(0x120F172A),
    input: Color(0xFFE8ECF1),
    ring: Color(0xFF6366F1),
    chart1: Color(0xFF6366F1),
    chart2: Color(0xFF8B5CF6),
    chart3: Color(0xFF10B981),
    chart4: Color(0xFFF59E0B),
    chart5: Color(0xFFF43F5E),
    sidebar: Color(0xFFFFFFFF),
    sidebarForeground: Color(0xFF0F172A),
    sidebarAccentForeground: Color(0xFF4F46E5),
    sidebarBorder: Color(0xFFE8ECF1),
    sidebarMuted: Color(0xFF64748B),
  );

  static const dark = SecuroColors(
    background: Color(0xFF0C0D12),
    foreground: Color(0xFFF0F0F5),
    card: Color(0xFF16171F),
    cardForeground: Color(0xFFF0F0F5),
    popover: Color(0xFF16171F),
    popoverForeground: Color(0xFFF0F0F5),
    primary: Color(0xFF818CF8),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFF252836),
    secondaryForeground: Color(0xFFF0F0F5),
    muted: Color(0xFF252836),
    mutedForeground: Color(0xFF8A8F9E),
    accent: Color(0xFF1E1B4B),
    accentForeground: Color(0xFFA5B4FC),
    destructive: Color(0xFFFB7185),
    destructiveForeground: Color(0xFF0C0D12),
    // Dark-mode hairline: a light wash at low alpha, mirroring the light
    // theme's near-black one — same "seam in the material" read, inverted.
    border: Color(0x1AFFFFFF),
    input: Color(0xFF2A2D3A),
    ring: Color(0xFF818CF8),
    // The dark block in index.css does not restate the chart tokens, so they
    // inherit the light values.
    chart1: Color(0xFF6366F1),
    chart2: Color(0xFF8B5CF6),
    chart3: Color(0xFF10B981),
    chart4: Color(0xFFF59E0B),
    chart5: Color(0xFFF43F5E),
    sidebar: Color(0xFF16171F),
    sidebarForeground: Color(0xFFF0F0F5),
    sidebarAccentForeground: Color(0xFFA5B4FC),
    sidebarBorder: Color(0xFF2A2D3A),
    sidebarMuted: Color(0xFF8A8F9E),
  );
}

/// `--radius: 0.625rem` on the web, at the browser default of 16px per rem.
class SecuroRadius {
  static const double base = 10;
  static const double sm = base - 4;
  static const double md = base - 2;
  static const double lg = base;
  static const double xl = base + 4;
  static const double xl2 = base + 8;
  static const double xl3 = base + 12;

  // Named tiers from the Apple Liquid Glass skill — reach for these on new
  // or updated surfaces so radius stops being picked ad hoc; the block above
  // stays for the call sites already tuned against it.
  static const double pill = 999;
  static const double chip = 6;
  static const double thumb = 12;
  static const double card = 18;
  static const double panel = 22;
  static const double hero = 26;
  static const double sheet = 16;
}
