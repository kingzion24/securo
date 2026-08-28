import '../../core/api/api_client.dart';
import '../../models/asset.dart';
import '../../models/asset_group.dart';

class AssetsRepository {
  AssetsRepository(this._api);
  final ApiClient _api;

  Future<List<Asset>> list() async {
    final data = await _api.get<List<dynamic>>('/assets');
    return data.map((e) => Asset.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Wallets (asset groups) — used to populate pickers elsewhere (e.g.
  /// Collections' wallet membership); managing a wallet's own name/icon
  /// stays a web-only flow for now.
  Future<List<AssetGroup>> listGroups() async {
    final data = await _api.get<List<dynamic>>('/asset-groups');
    return data.map((e) => AssetGroup.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// `valuationMethod` is one of the server's three methods:
  ///  - `manual` — a plain manually-valued holding (`currentValue`/`units`).
  ///  - `market_price` — ticker-priced; the server fetches the live quote
  ///    and seeds the opening buy from `units`/`unitPrice` (falling back to
  ///    "bought at market now" when `unitPrice` is omitted).
  ///  - `growth_rule` — a modeled holding (e.g. real estate) that accrues
  ///    from `purchasePrice`/`purchaseDate` at `growthRate` every
  ///    `growthFrequency`, starting `growthStartDate` (or the purchase date).
  Future<void> create({
    required String name,
    required String type,
    String currency = 'USD',
    double? units,
    double? currentValue,
    String valuationMethod = 'manual',
    String? ticker,
    String? tickerExchange,
    double? unitPrice,
    String? purchaseDate,
    double? purchasePrice,
    String? growthType,
    double? growthRate,
    String? growthFrequency,
    String? growthStartDate,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/assets',
      body: {
        'name': name,
        'type': type,
        'currency': currency,
        'valuation_method': valuationMethod,
        'units': ?units,
        'current_value': ?currentValue,
        'ticker': ?ticker,
        'ticker_exchange': ?tickerExchange,
        'unit_price': ?unitPrice,
        'purchase_date': ?purchaseDate,
        'purchase_price': ?purchasePrice,
        'growth_type': ?growthType,
        'growth_rate': ?growthRate,
        'growth_frequency': ?growthFrequency,
        'growth_start_date': ?growthStartDate,
      },
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? type,
    double? units,
    double? purchasePrice,
    String? purchaseDate,
    String? growthType,
    double? growthRate,
    String? growthFrequency,
    String? growthStartDate,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/assets/$id',
      body: {
        'name': ?name,
        'type': ?type,
        'units': ?units,
        'purchase_price': ?purchasePrice,
        'purchase_date': ?purchaseDate,
        'growth_type': ?growthType,
        'growth_rate': ?growthRate,
        'growth_frequency': ?growthFrequency,
        'growth_start_date': ?growthStartDate,
      },
    );
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/assets/$id');

  /// Records a new value for the asset — the manual equivalent of an
  /// automatic price update, and how a manual asset's `current_value`
  /// actually gets changed after creation.
  Future<void> addValue(String assetId, {required double amount, required String date}) async {
    await _api.post<Map<String, dynamic>>(
      '/assets/$assetId/values',
      body: {'amount': amount, 'date': date},
    );
  }

  /// Autocomplete for the ticker field on the add-asset form.
  Future<List<MarketSymbolMatch>> marketSearch(String query) async {
    final data = await _api.get<List<dynamic>>('/assets/market/search', query: {'q': query});
    return data.map((e) => MarketSymbolMatch.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Live quote, used to preview value before saving a market-priced asset.
  Future<MarketSymbolQuote> marketQuote(String symbol) async {
    final data =
        await _api.get<Map<String, dynamic>>('/assets/market/quote', query: {'symbol': symbol});
    return MarketSymbolQuote.fromJson(data);
  }

  /// Pulls a fresh live price for an existing market-priced holding.
  Future<Asset> refreshPrice(String assetId) async {
    final data = await _api.post<Map<String, dynamic>>('/assets/$assetId/refresh-price');
    return Asset.fromJson(data);
  }

  Future<List<AssetTransaction>> transactions(String assetId) async {
    final data = await _api.get<List<dynamic>>('/assets/$assetId/transactions');
    return data.map((e) => AssetTransaction.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Records a buy or sell against an existing market-priced holding —
  /// the ledger entries `averagePrice`/`totalInvested`/`realizedGain` are
  /// derived from.
  Future<void> recordTrade(
    String assetId, {
    required String kind,
    required double quantity,
    required double price,
    double fee = 0,
    required String date,
    String? notes,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/assets/$assetId/transactions',
      body: {
        'kind': kind,
        'quantity': quantity,
        'price': price,
        'fee': fee,
        'date': date,
        'notes': ?notes,
      },
    );
  }
}
