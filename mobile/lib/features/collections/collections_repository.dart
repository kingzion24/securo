import '../../core/api/api_client.dart';
import '../../models/collection.dart';

class CollectionsRepository {
  CollectionsRepository(this._api);
  final ApiClient _api;

  Future<List<Collection>> list() async {
    final data = await _api.get<List<dynamic>>('/collections');
    return data.map((e) => Collection.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> create({
    required String name,
    String icon = 'folder',
    String color = '#6366F1',
    List<String> accountIds = const [],
    List<String> walletIds = const [],
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/collections',
      body: {
        'name': name,
        'icon': icon,
        'color': color,
        'account_ids': accountIds,
        'wallet_ids': walletIds,
      },
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? icon,
    String? color,
    List<String>? accountIds,
    List<String>? walletIds,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/collections/$id',
      body: {
        'name': ?name,
        'icon': ?icon,
        'color': ?color,
        'account_ids': ?accountIds,
        'wallet_ids': ?walletIds,
      },
    );
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/collections/$id');
}
