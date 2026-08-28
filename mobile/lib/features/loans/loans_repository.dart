import '../../core/api/api_client.dart';
import '../../models/loan.dart';

class LoansRepository {
  LoansRepository(this._api);
  final ApiClient _api;

  Future<List<Loan>> list() async {
    final data = await _api.get<List<dynamic>>('/loans');
    return data.map((e) => Loan.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> create({
    required String personName,
    required String direction,
    required double principalAmount,
    required String date,
    String currency = 'USD',
    String? note,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/loans',
      body: {
        'person_name': personName,
        'direction': direction,
        'principal_amount': principalAmount,
        'currency': currency,
        'date': date,
        'note': ?note,
      },
    );
  }

  Future<void> update(
    String id, {
    String? personName,
    String? direction,
    double? principalAmount,
    String? currency,
    String? date,
    String? note,
    String? status,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/loans/$id',
      body: {
        'person_name': ?personName,
        'direction': ?direction,
        'principal_amount': ?principalAmount,
        'currency': ?currency,
        'date': ?date,
        'note': ?note,
        'status': ?status,
      },
    );
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/loans/$id');

  Future<void> addRepayment(
    String loanId, {
    required double amount,
    required String date,
    String? note,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/loans/$loanId/repayments',
      body: {'amount': amount, 'date': date, 'note': ?note},
    );
  }
}
