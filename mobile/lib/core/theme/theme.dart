
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

/// Apple's two type disciplines applied app-wide: large titles get *negative*
/// tracking (letters read too far apart at big sizes otherwise; body stays
/// untouched), and every style carries tabular figures, so a column of
/// amounts lines up digit-for-digit instead of each row reflowing to its own
/// width. Tabular figures are a no-op on non-digit glyphs, so this is safe to
/// apply blanket rather than hunting down every money `Text`.
TextTheme _appleType(TextTheme base) {
  TextStyle? tabular(TextStyle? style) =>
      style?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
  TextStyle? tighten(TextStyle? style, double tracking) => tabular(
        style?.copyWith(letterSpacing: tracking * (style.fontSize ?? 16)),
      );

  return base.copyWith(
    displayLarge: tighten(base.displayLarge, -0.02),
    displayMedium: tighten(base.displayMedium, -0.02),
    displaySmall: tighten(base.displaySmall, -0.02),
    headlineLarge: tighten(base.headlineLarge, -0.02),
    headlineMedium: tighten(base.headlineMedium, -0.015),
    headlineSmall: tighten(base.headlineSmall, -0.015),
    titleLarge: tighten(base.titleLarge, -0.01),
    titleMedium: tighten(base.titleMedium, -0.005),
    titleSmall: tabular(base.titleSmall),
    bodyLarge: tabular(base.bodyLarge),
    bodyMedium: tabular(base.bodyMedium),
    bodySmall: tabular(base.bodySmall),
    labelLarge: tabular(base.labelLarge),
    labelMedium: tabular(base.labelMedium),
    labelSmall: tabular(base.labelSmall),
  );
}

/// Exposes the raw token set to widgets, so they can reach for a colour the
/// Material [ColorScheme] has no slot for (chart series, sidebar, muted text)
/// without threading it through every constructor.
@immutable
class SecuroTheme extends ThemeExtension<SecuroTheme> {
  const SecuroTheme({required this.colors});

  final SecuroColors colors;

  static SecuroColors of(BuildContext context) =>
      Theme.of(context).extension<SecuroTheme>()!.colors;

  @override
  SecuroTheme copyWith({SecuroColors? colors}) =>
      SecuroTheme(colors: colors ?? this.colors);

  @override
  SecuroTheme lerp(ThemeExtension<SecuroTheme>? other, double t) =>
      t < 0.5 ? this : (other as SecuroTheme? ?? this);
}

ThemeData buildSecuroTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? SecuroColors.dark : SecuroColors.light;

  // index.css declares `font-family: 'Geist', 'Inter', system-ui`. Geist is not
  // in the google_fonts catalogue, so this uses the web app's own next choice.
  final textTheme = _appleType(
    GoogleFonts.interTextTheme(ThemeData(brightness: brightness).textTheme)
        .apply(bodyColor: c.foreground, displayColor: c.foreground),
  );

  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.primary,
    onPrimary: c.primaryForeground,
    secondary: c.secondary,
    onSecondary: c.secondaryForeground,
    error: c.destructive,
    onError: c.destructiveForeground,
    surface: c.card,
    onSurface: c.cardForeground,
    surfaceContainerHighest: c.muted,
    onSurfaceVariant: c.mutedForeground,
    outline: c.border,
    outlineVariant: c.border,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.background,
    canvasColor: c.background,
    dividerColor: c.border,
    textTheme: textTheme,
    extensions: [SecuroTheme(colors: c)],
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.foreground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: c.foreground,
      ),
    ),
    cardTheme: CardThemeData(
      color: c.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.card),
        side: BorderSide(color: c.border),
      ),
    ),
    dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: textTheme.bodyMedium?.copyWith(color: c.mutedForeground),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        borderSide: BorderSide(color: c.input),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        borderSide: BorderSide(color: c.input),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        borderSide: BorderSide(color: c.ring, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        borderSide: BorderSide(color: c.destructive),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        borderSide: BorderSide(color: c.destructive, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.primary,
        foregroundColor: c.primaryForeground,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SecuroRadius.md),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.foreground,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        side: BorderSide(color: c.border),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SecuroRadius.md),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.primary,
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.sidebar,
      surfaceTintColor: Colors.transparent,
      indicatorColor: c.accent,
      elevation: 0,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          size: 22,
          color: s.contains(WidgetState.selected)
              ? c.accentForeground
              : c.sidebarMuted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
          color: s.contains(WidgetState.selected)
              ? c.accentForeground
              : c.sidebarMuted,
        ),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.popover,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: c.border,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SecuroRadius.panel),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.popover,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.xl),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.secondary,
      selectedColor: c.accent,
      side: BorderSide(color: c.border),
      labelStyle: textTheme.labelMedium!.copyWith(color: c.foreground),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.xl3),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.foreground,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: c.background),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SecuroRadius.md),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.primary,
      linearTrackColor: c.muted,
      circularTrackColor: c.muted,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: c.mutedForeground,
      textColor: c.foreground,
    ),
  );
}
