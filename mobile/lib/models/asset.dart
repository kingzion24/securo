double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

double? _toDoubleOrNull(Object? value) =>
    value == null ? null : _toDouble(value);

class Asset {
  const Asset({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    this.units,
    this.currentValue,
    this.currentValuePrimary,
    this.gainLoss,
    this.gainLossPrimary,
    required this.isArchived,
    this.valuationMethod = 'manual',
    this.ticker,
    this.tickerExchange,
    this.lastPrice,
    this.lastPriceAt,
    this.logoUrl,
    this.growthType,
    this.growthRate,
    this.growthFrequency,
    this.growthStartDate,
    this.averagePrice,
    this.totalInvested,
    this.realizedGain,
    this.transactionCount = 0,
    this.groupId,
    this.purchaseDate,
    this.purchasePrice,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String? ?? 'other',
        currency: json['currency'] as String? ?? 'USD',
        units: _toDoubleOrNull(json['units']),
        currentValue: _toDoubleOrNull(json['current_value']),
        currentValuePrimary: _toDoubleOrNull(json['current_value_primary']),
        gainLoss: _toDoubleOrNull(json['gain_loss']),
        gainLossPrimary: _toDoubleOrNull(json['gain_loss_primary']),
        isArchived: json['is_archived'] as bool? ?? false,
        valuationMethod: json['valuation_method'] as String? ?? 'manual',
        ticker: json['ticker'] as String?,
        tickerExchange: json['ticker_exchange'] as String?,
        lastPrice: _toDoubleOrNull(json['last_price']),
        lastPriceAt: json['last_price_at'] as String?,
        logoUrl: json['logo_url'] as String?,
        growthType: json['growth_type'] as String?,
        growthRate: _toDoubleOrNull(json['growth_rate']),
        growthFrequency: json['growth_frequency'] as String?,
        growthStartDate: json['growth_start_date'] as String?,
        averagePrice: _toDoubleOrNull(json['average_price']),
        totalInvested: _toDoubleOrNull(json['total_invested']),
        realizedGain: _toDoubleOrNull(json['realized_gain']),
        transactionCount: json['transaction_count'] as int? ?? 0,
        groupId: json['group_id'] as String?,
        purchaseDate: json['purchase_date'] as String?,
        purchasePrice: _toDoubleOrNull(json['purchase_price']),
      );

  final String id;
  final String name;
  final String type;
  final String currency;
  final double? units;
  final double? currentValue;
  final double? currentValuePrimary;
  final double? gainLoss;
  final double? gainLossPrimary;
  final bool isArchived;

  /// `manual` or `market` (ticker-priced).
  final String valuationMethod;
  final String? ticker;
  final String? tickerExchange;
  final double? lastPrice;
  final String? lastPriceAt;
  final String? logoUrl;

  /// Growth modeling for manual assets with no live price (e.g. real
  /// estate) — `linear`/`compound`, applied at `growthFrequency` from
  /// `growthStartDate`.
  final String? growthType;
  final double? growthRate;
  final String? growthFrequency;
  final String? growthStartDate;

  final double? averagePrice;
  final double? totalInvested;
  final double? realizedGain;
  final int transactionCount;
  final String? groupId;
  final String? purchaseDate;
  final double? purchasePrice;

  bool get isMarketPriced => valuationMethod == 'market_price';
  bool get isGrowthModeled => valuationMethod == 'growth_rule';
}

class AssetTransaction {
  const AssetTransaction({
    required this.id,
    required this.assetId,
    required this.kind,
    required this.quantity,
    required this.price,
    required this.fee,
    required this.date,
    this.notes,
  });

  factory AssetTransaction.fromJson(Map<String, dynamic> json) => AssetTransaction(
        id: json['id'] as String,
        assetId: json['asset_id'] as String,
        kind: json['kind'] as String,
        quantity: _toDouble(json['quantity']),
        price: _toDouble(json['price']),
        fee: _toDouble(json['fee']),
        date: json['date'] as String,
        notes: json['notes'] as String?,
      );

  final String id;
  final String assetId;

  /// `buy` or `sell`.
  final String kind;
  final double quantity;
  final double price;
  final double fee;
  final String date;
  final String? notes;
}

class MarketSymbolMatch {
  const MarketSymbolMatch({
    required this.symbol,
    this.name,
    this.exchange,
    this.quoteType,
  });

  factory MarketSymbolMatch.fromJson(Map<String, dynamic> json) => MarketSymbolMatch(
        symbol: json['symbol'] as String,
        name: json['name'] as String?,
        exchange: json['exchange'] as String?,
        quoteType: json['quote_type'] as String?,
      );

  final String symbol;
  final String? name;
  final String? exchange;
  final String? quoteType;
}

class MarketSymbolQuote {
  const MarketSymbolQuote({
    required this.symbol,
    this.name,
    this.exchange,
    required this.currency,
    required this.price,
    this.quoteType,
    this.logoUrl,
  });

  factory MarketSymbolQuote.fromJson(Map<String, dynamic> json) => MarketSymbolQuote(
        symbol: json['symbol'] as String,
        name: json['name'] as String?,
        exchange: json['exchange'] as String?,
        currency: json['currency'] as String,
        price: _toDouble(json['price']),
        quoteType: json['quote_type'] as String?,
        logoUrl: json['logo_url'] as String?,
      );

  final String symbol;
  final String? name;
  final String? exchange;
  final String currency;
  final double price;
  final String? quoteType;
  final String? logoUrl;
}
