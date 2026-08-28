import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/providers.dart';
import '../../models/dashboard.dart';
import '../workspace/workspace_controller.dart';

class DashboardRepository {
  DashboardRepository(this._api);
  final ApiClient _api;

  Future<DashboardSummary> summary() async {
    final data = await _api.get<Map<String, dynamic>>('/dashboard/summary');
    return DashboardSummary.fromJson(data);
  }

  Future<List<SpendingByCategory>> spendingByCategory() async {
    final data =
        await _api.get<List<dynamic>>('/dashboard/spending-by-category');
    return data
        .map((e) => SpendingByCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MonthlyTrend>> monthlyTrend() async {
    final data = await _api.get<List<dynamic>>('/dashboard/monthly-trend');
    return data
        .map((e) => MonthlyTrend.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BalanceHistory> balanceHistory() async {
    final data = await _api.get<Map<String, dynamic>>(
      '/dashboard/balance-history',
    );
    return BalanceHistory.fromJson(data);
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepository(ref.watch(apiClientProvider)),
);

/// Each panel loads independently so a slow chart never holds up the summary
/// cards, and one failing endpoint does not blank the whole screen.
final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) {
  ref.watch(activeWorkspaceIdProvider);
  return ref.watch(dashboardRepositoryProvider).summary();
});

final spendingByCategoryProvider =
    FutureProvider<List<SpendingByCategory>>((ref) {
  ref.watch(activeWorkspaceIdProvider);
  return ref.watch(dashboardRepositoryProvider).spendingByCategory();
});

final monthlyTrendProvider = FutureProvider<List<MonthlyTrend>>((ref) {
  ref.watch(activeWorkspaceIdProvider);
  return ref.watch(dashboardRepositoryProvider).monthlyTrend();
});

final balanceHistoryProvider = FutureProvider<BalanceHistory>((ref) {
  ref.watch(activeWorkspaceIdProvider);
  return ref.watch(dashboardRepositoryProvider).balanceHistory();
});
