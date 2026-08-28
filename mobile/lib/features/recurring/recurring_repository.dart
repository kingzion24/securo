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

  Future<void> create({
    required String description,
    required double amount,
    required String type,
    required String frequency,
    required String startDate,
    required String accountId,
    String currency = 'USD',
    String? categoryId,
    int? dayOfMonth,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/recurring-transactions',
      body: {
        'description': description,
        'amount': amount,
        'currency': currency,
        'type': type,
        'frequency': frequency,
        'start_date': startDate,
        'account_id': accountId,
        'category_id': ?categoryId,
        'day_of_month': ?dayOfMonth,
      },
    );
  }

  Future<void> update(
    String id, {
    String? description,
    double? amount,
    String? type,
    String? frequency,
    String? categoryId,
    bool? isActive,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/recurring-transactions/$id',
      body: {
        'description': ?description,
        'amount': ?amount,
        'type': ?type,
        'frequency': ?frequency,
        'category_id': ?categoryId,
        'is_active': ?isActive,
      },
    );
  }

  Future<void> delete(String id) =>
      _api.delete<dynamic>('/recurring-transactions/$id');
}
