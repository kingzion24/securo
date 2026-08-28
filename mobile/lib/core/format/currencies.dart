/// The common-case currency shortlist offered by every currency picker in
/// the app. The server accepts a much longer, deployment-configured list —
/// callers showing an existing value outside this set must still include it
/// (see `Settings`'s `currencyChoices` for the pattern), so a dropdown never
/// throws on a valid-but-uncommon currency.
const List<String> kCurrencyOptions = [
  'USD', 'EUR', 'GBP', 'BRL', 'CAD', 'AUD', 'CHF', 'ARS', 'JPY', 'MXN',
  'INR', 'SEK', 'DKK', 'NOK', 'PLN', 'CZK', 'HUF', 'RON', 'TZS', 'KES',
];
