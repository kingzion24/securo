const _kRegionalIndicatorA = 0x1f1e6;
const _kLetterA = 0x41;

/// Emoji flag for an ISO 3166-1 alpha-2 country code, derived by shifting
/// the two letters into Unicode's regional-indicator block — mirrors
/// `frontend/src/lib/country-flag.ts` so a new jurisdiction pack needs no
/// change here. Returns '' for anything that isn't exactly two letters
/// (a tax regime code, not a country, has no flag).
String countryFlag(String code) {
  final upper = code.trim().toUpperCase();
  if (!RegExp(r'^[A-Z]{2}$').hasMatch(upper)) return '';
  return String.fromCharCodes(
    upper.codeUnits.map((c) => _kRegionalIndicatorA + c - _kLetterA),
  );
}
