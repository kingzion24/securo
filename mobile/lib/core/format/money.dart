import 'package:intl/intl.dart';

/// Currency and date formatting, mirroring `frontend/src/lib/format.ts`.
///
/// The workspace carries a locale and a default currency; both are passed in
/// rather than read from the device, so the phone shows the same numbers the
/// browser does.
String formatMoney(
  double amount, {
  required String currency,
  String? locale,
  bool compact = false,
}) {
  if (compact && amount.abs() >= 1000) {
    return NumberFormat.compactCurrency(
      locale: locale,
      name: currency,
      symbol: currencySymbol(currency, locale: locale),
    ).format(amount);
  }
  return NumberFormat.currency(
    locale: locale,
    name: currency,
    symbol: currencySymbol(currency, locale: locale),
  ).format(amount);
}

String currencySymbol(String currency, {String? locale}) {
  try {
    return NumberFormat.simpleCurrency(locale: locale, name: currency)
        .currencySymbol;
  } catch (_) {
    // An unrecognised ISO code (or one intl has no symbol for) is shown as the
    // code itself, which is clearer than a blank prefix.
    return '$currency ';
  }
}

String formatSignedMoney(
  double amount, {
  required String currency,
  String? locale,
}) {
  final formatted = formatMoney(amount.abs(), currency: currency, locale: locale);
  return amount < 0 ? '-$formatted' : '+$formatted';
}

String formatPercent(double value, {String? locale}) =>
    NumberFormat.decimalPercentPattern(locale: locale, decimalDigits: 1)
        .format(value / 100);

/// Parses the `YYYY-MM-DD` dates the API returns, tolerating a full timestamp.
DateTime? parseApiDate(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

String formatDate(String? value, {String? locale}) {
  final date = parseApiDate(value);
  if (date == null) return '';
  return DateFormat.yMMMd(locale).format(date);
}

String formatDayMonth(String? value, {String? locale}) {
  final date = parseApiDate(value);
  if (date == null) return '';
  return DateFormat.MMMd(locale).format(date);
}

/// `2026-08` → `Aug 2026`, for the month labels on trends and budgets.
String formatMonthLabel(String month, {String? locale}) {
  final parts = month.split('-');
  if (parts.length < 2) return month;
  final year = int.tryParse(parts[0]);
  final monthNumber = int.tryParse(parts[1]);
  if (year == null || monthNumber == null) return month;
  return DateFormat.yMMM(locale).format(DateTime(year, monthNumber));
}
