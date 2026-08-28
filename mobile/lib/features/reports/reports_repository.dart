import '../../core/api/api_client.dart';
import '../../models/report.dart';

enum ReportKind {
  netWorth('/reports/net-worth', 'Net worth'),
  incomeExpenses('/reports/income-expenses', 'Income & Expenses'),
  cashFlow('/reports/cash-flow', 'Cash flow');

  const ReportKind(this.path, this.label);
  final String path;
  final String label;
}

class ReportsRepository {
  ReportsRepository(this._api);

  final ApiClient _api;

  Future<Report> fetch(ReportKind kind) async {
    final data = await _api.get<Map<String, dynamic>>(kind.path);
    return Report.fromJson(data);
  }
}
