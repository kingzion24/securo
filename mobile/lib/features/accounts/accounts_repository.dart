import '../../core/api/api_client.dart';
import '../../models/account.dart';

class AccountsRepository {
  AccountsRepository(this._api);
  final ApiClient _api;

  Future<List<Account>> list({bool includeClosed = false}) async {
    final data = await _api.get<List<dynamic>>(
      '/accounts',
      query: {'include_closed': includeClosed},
    );
    return data
        .map((e) => Account.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Account> get(String id) async {
    final data = await _api.get<Map<String, dynamic>>('/accounts/$id');
    return Account.fromJson(data);
  }

  Future<Account> create({
    required String name,
    required String type,
    double balance = 0,
    String currency = 'USD',
    double? creditLimit,
    int? statementCloseDay,
    int? paymentDueDay,
    double? minimumPayment,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/accounts',
      body: {
        'name': name,
        'type': type,
        'balance': balance,
        'currency': currency,
        'credit_limit': ?creditLimit,
        'statement_close_day': ?statementCloseDay,
        'payment_due_day': ?paymentDueDay,
        'minimum_payment': ?minimumPayment,
      },
    );
    return Account.fromJson(data);
  }

  Future<Account> update(
    String id, {
    String? name,
    String? displayName,
    String? type,
    double? balance,
    double? creditLimit,
    int? statementCloseDay,
    int? paymentDueDay,
    double? minimumPayment,
  }) async {
    final data = await _api.patch<Map<String, dynamic>>(
      '/accounts/$id',
      body: {
        'name': ?name,
        'display_name': ?displayName,
        'type': ?type,
        'balance': ?balance,
        'credit_limit': ?creditLimit,
        'statement_close_day': ?statementCloseDay,
        'payment_due_day': ?paymentDueDay,
        'minimum_payment': ?minimumPayment,
      },
    );
    return Account.fromJson(data);
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/accounts/$id');

  Future<Account> close(String id) async {
    final data = await _api.post<Map<String, dynamic>>('/accounts/$id/close');
    return Account.fromJson(data);
  }

  Future<Account> reopen(String id) async {
    final data = await _api.post<Map<String, dynamic>>('/accounts/$id/reopen');
    return Account.fromJson(data);
  }
}
