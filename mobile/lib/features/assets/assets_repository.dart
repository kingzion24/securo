import '../../core/api/api_client.dart';
import '../../models/asset.dart';

class AssetsRepository {
  AssetsRepository(this._api);
  final ApiClient _api;

  Future<List<Asset>> list() async {
    final data = await _api.get<List<dynamic>>('/assets');
    return data.map((e) => Asset.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Manual-valuation assets only — market-priced (ticker) holdings and
  /// growth-modeled assets stay a web-only flow for now, same restraint call
  /// as elsewhere in the app.
  Future<void> create({
    required String name,
    required String type,
    String currency = 'USD',
    double? units,
    double? currentValue,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/assets',
      body: {
        'name': name,
        'type': type,
        'currency': currency,
        'valuation_method': 'manual',
        'units': ?units,
        'current_value': ?currentValue,
      },
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? type,
    double? units,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/assets/$id',
      body: {
        'name': ?name,
        'type': ?type,
        'units': ?units,
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
}
