import 'package:flutter/widgets.dart';

/// Parses a `#RRGGBB` / `#AARRGGBB` string from the API (category, group, and
/// report colors) into a [Color]. Null on anything that doesn't parse, so
/// callers can fall back to a theme color instead of rendering black.
Color? parseHexColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  final cleaned = hex.replaceFirst('#', '');
  final value = int.tryParse(cleaned, radix: 16);
  if (value == null) return null;
  return Color(cleaned.length == 6 ? 0xFF000000 | value : value);
}
