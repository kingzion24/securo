import '../../core/api/api_client.dart';
import '../../models/budget.dart';

class BudgetsRepository {
  BudgetsRepository(this._api);
  final ApiClient _api;

  /// Current month's budget vs. actual, per category — what the web app's
  /// budgets page opens on.
  Future<List<BudgetVsActual>> comparisonForCurrentMonth() async {
    final now = DateTime.now();
    final month =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-01';
    final data = await _api.get<List<dynamic>>(
      '/budgets/comparison',
      query: {'month': month},
    );
    return data
        .map((e) => BudgetVsActual.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
