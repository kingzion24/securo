import '../../core/api/api_client.dart';
import '../../models/transaction.dart';

class TransactionsPage {
  const TransactionsPage({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<Transaction> items;
  final int total;
  final int page;
  final int limit;

  bool get hasMore => page * limit < total;
}

class TransactionsRepository {
  TransactionsRepository(this._api);

  final ApiClient _api;

  Future<TransactionsPage> list({
    int page = 1,
    int limit = 30,
    String? query,
    String? accountId,
  }) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/transactions',
      query: {
        'page': page,
        'limit': limit,
        if (query != null && query.isNotEmpty) 'q': query,
        'account_id': ?accountId,
      },
    );
    final items = (data['items'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
    return TransactionsPage(
      items: items,
      total: data['total'] as int,
      page: data['page'] as int,
      limit: data['limit'] as int,
    );
  }

  Future<Transaction> create({
    required String description,
    required double amount,
    required String date,
    required String type,
    required String accountId,
    String? categoryId,
    String? payeeId,
    String? currency,
    String? notes,
    Map<String, dynamic>? splits,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/transactions',
      body: {
        'description': description,
        'amount': amount,
        'date': date,
        'type': type,
        'account_id': accountId,
        'category_id': ?categoryId,
        'payee_id': ?payeeId,
        'currency': ?currency,
        'notes': ?notes,
        'splits': ?splits,
      },
    );
    return Transaction.fromJson(data);
  }

  /// Fans a single purchase out into `installments` equal, evenly-spaced
  /// rows — the first posted, the rest pending — via the dedicated series
  /// endpoint rather than repeated individual `create()` calls, so the
  /// server ties them together with one installment fingerprint.
  Future<List<Transaction>> createInstallmentSeries({
    required String description,
    required double amount,
    required String date,
    required String type,
    required String accountId,
    required int installments,
    String frequency = 'monthly',
    String? categoryId,
    String? payeeId,
    String? currency,
    String? notes,
  }) async {
    final data = await _api.post<List<dynamic>>(
      '/transactions/installments',
      body: {
        'base': {
          'description': description,
          'amount': amount,
          'date': date,
          'type': type,
          'account_id': accountId,
          'category_id': ?categoryId,
          'payee_id': ?payeeId,
          'currency': ?currency,
          'notes': ?notes,
        },
        'installments': installments,
        'frequency': frequency,
      },
    );
    return data.map((e) => Transaction.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Transaction> update(
    String id, {
    String? description,
    double? amount,
    String? date,
    String? type,
    String? accountId,
    String? categoryId,
    String? payeeId,
    String? notes,
    Map<String, dynamic>? splits,
    String applyTo = 'this',
  }) async {
    final data = await _api.patch<Map<String, dynamic>>(
      '/transactions/$id',
      body: {
        'description': ?description,
        'amount': ?amount,
        'date': ?date,
        'type': ?type,
        'account_id': ?accountId,
        'category_id': ?categoryId,
        'payee_id': ?payeeId,
        'notes': ?notes,
        'splits': ?splits,
        'apply_to': applyTo,
      },
    );
    return Transaction.fromJson(data);
  }

  Future<void> delete(String id, {String applyTo = 'this'}) =>
      _api.delete<dynamic>('/transactions/$id?apply_to=$applyTo');

  Future<int> bulkDelete(List<String> ids) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/transactions/bulk-delete',
      body: {'transaction_ids': ids},
    );
    return data['deleted'] as int? ?? 0;
  }

  Future<int> bulkCategorize(List<String> ids, String? categoryId) async {
    final data = await _api.patch<Map<String, dynamic>>(
      '/transactions/bulk-categorize',
      body: {'transaction_ids': ids, 'category_id': categoryId},
    );
    return data['updated'] as int? ?? 0;
  }

  /// Moves money between two of the user's own accounts — creates a linked
  /// debit/credit pair, not a plain transaction.
  Future<void> createTransfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required String date,
    required String description,
    double? destinationAmount,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/transactions/transfer',
      body: {
        'from_account_id': fromAccountId,
        'to_account_id': toAccountId,
        'amount': amount,
        'date': date,
        'description': description,
        'destination_amount': ?destinationAmount,
      },
    );
  }
}
