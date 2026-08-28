import '../../core/api/api_client.dart';
import '../../models/rule.dart';

class RulesRepository {
  RulesRepository(this._api);
  final ApiClient _api;

  Future<List<Rule>> list() async {
    final data = await _api.get<List<dynamic>>('/rules');
    return data.map((e) => Rule.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Scoped to the common case — one condition, one "set category" action —
  /// rather than the web editor's full nested AND/OR group builder and five
  /// action types. Covers the large majority of real rules ("if description
  /// contains X, categorize as Y"); anything more elaborate stays a web-only
  /// edit for now.
  Future<void> create({
    required String name,
    required String field,
    required String op,
    required String value,
    required String categoryId,
    bool isActive = true,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/rules',
      body: {
        'name': name,
        'conditions_op': 'and',
        'conditions': [
          {'field': field, 'op': op, 'value': value},
        ],
        'actions': [
          {'op': 'set_category', 'value': categoryId},
        ],
        'is_active': isActive,
      },
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? field,
    String? op,
    String? value,
    String? categoryId,
    bool? isActive,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/rules/$id',
      body: {
        'name': ?name,
        if (field != null && op != null && value != null)
          'conditions': [
            {'field': field, 'op': op, 'value': value},
          ],
        if (categoryId != null)
          'actions': [
            {'op': 'set_category', 'value': categoryId},
          ],
        'is_active': ?isActive,
      },
    );
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/rules/$id');
}
