import '../../core/api/api_client.dart';
import '../../models/recurring_transaction.dart';

class RecurringRepository {
  RecurringRepository(this._api);
  final ApiClient _api;

  Future<List<RecurringTransaction>> list() async {
    final data = await _api.get<List<dynamic>>('/recurring-transactions');
    return data
        .map((e) => RecurringTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
