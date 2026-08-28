import '../../core/api/api_client.dart';
import '../../models/rule.dart';

class RulesRepository {
  RulesRepository(this._api);
  final ApiClient _api;

  Future<List<Rule>> list() async {
    final data = await _api.get<List<dynamic>>('/rules');
    return data.map((e) => Rule.fromJson(e as Map<String, dynamic>)).toList();
  }
}
