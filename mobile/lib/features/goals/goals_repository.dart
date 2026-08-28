import '../../core/api/api_client.dart';
import '../../models/goal.dart';

class GoalsRepository {
  GoalsRepository(this._api);
  final ApiClient _api;

  Future<List<GoalSummary>> list() async {
    final data = await _api.get<List<dynamic>>('/goals/summary');
    return data
        .map((e) => GoalSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
