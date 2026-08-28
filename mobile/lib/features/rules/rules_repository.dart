import '../../core/api/api_client.dart';
import '../../models/rule.dart';

class RulesRepository {
  RulesRepository(this._api);
  final ApiClient _api;

  Future<List<Rule>> list() async {
    final data = await _api.get<List<dynamic>>('/rules');
    return data.map((e) => Rule.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// `conditions` mixes leaf `{field, op, value}` maps and one level of
  /// group maps (`{op: 'and'|'or', conditions: [leaf, ...]}`) — matching the
  /// backend's `RuleConditionNode` union, which caps nesting at two levels.
  Future<void> create({
    required String name,
    required String conditionsOp,
    required List<Map<String, dynamic>> conditions,
    required List<Map<String, dynamic>> actions,
    bool isActive = true,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/rules',
      body: {
        'name': name,
        'conditions_op': conditionsOp,
        'conditions': conditions,
        'actions': actions,
        'is_active': isActive,
      },
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? conditionsOp,
    List<Map<String, dynamic>>? conditions,
    List<Map<String, dynamic>>? actions,
    bool? isActive,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/rules/$id',
      body: {
        'name': ?name,
        'conditions_op': ?conditionsOp,
        'conditions': ?conditions,
        'actions': ?actions,
        'is_active': ?isActive,
      },
    );
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/rules/$id');
}
