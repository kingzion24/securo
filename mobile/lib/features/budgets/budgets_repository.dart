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

  /// Sets (creates or overwrites) the budget for [categoryId] this month.
  /// The backend keys a budget by (category, month), so posting again for a
  /// category that already has one for the month replaces the amount.
  Future<void> setForCurrentMonth({
    required String categoryId,
    required double amount,
    bool isRecurring = false,
  }) async {
    final now = DateTime.now();
    final month =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-01';
    await _api.post<Map<String, dynamic>>(
      '/budgets',
      body: {
        'category_id': categoryId,
        'amount': amount,
        'month': month,
        'is_recurring': isRecurring,
      },
    );
  }

  /// `BudgetVsActual` (what the list screen renders) has no budget-row id —
  /// it's a comparison view keyed by category, not the raw `Budget` table —
  /// so deleting has to resolve the real id via the raw list first.
  Future<void> deleteForCategory(String categoryId) async {
    final now = DateTime.now();
    final month =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-01';
    final data = await _api.get<List<dynamic>>('/budgets', query: {'month': month});
    final match = data.cast<Map<String, dynamic>>().firstWhere(
          (b) => b['category_id'] == categoryId,
          orElse: () => const {},
        );
    final id = match['id'] as String?;
    if (id == null) return;
    await _api.delete<dynamic>('/budgets/$id');
  }
}
