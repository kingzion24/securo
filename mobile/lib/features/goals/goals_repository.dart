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

  Future<void> create({
    required String name,
    required double targetAmount,
    double currentAmount = 0,
    String currency = 'USD',
    String? targetDate,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/goals',
      body: {
        'name': name,
        'target_amount': targetAmount,
        'current_amount': currentAmount,
        'currency': currency,
        'tracking_type': 'manual',
        'target_date': ?targetDate,
      },
    );
  }

  Future<void> update(
    String id, {
    String? name,
    double? targetAmount,
    double? currentAmount,
    String? targetDate,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/goals/$id',
      body: {
        'name': ?name,
        'target_amount': ?targetAmount,
        'current_amount': ?currentAmount,
        'target_date': ?targetDate,
      },
    );
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/goals/$id');
}
