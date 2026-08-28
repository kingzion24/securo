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

/// The filter set the web app's filter bar exposes, minus what makes no
/// sense on a phone (column sort, saved views). Every field maps 1:1 to a
/// `GET /transactions` query param the backend already accepts.
class TransactionFilters {
  const TransactionFilters({
    this.accountIds = const [],
    this.categoryIds = const [],
    this.payeeId,
    this.type,
    this.status,
    this.fromDate,
    this.toDate,
    this.minAmount,
    this.maxAmount,
    this.excludeIgnored = false,
    this.uncategorized = false,
  });

  final List<String> accountIds;
  final List<String> categoryIds;
  final String? payeeId;

  /// 'debit' or 'credit'.
  final String? type;

  /// 'posted' or 'pending'.
  final String? status;
  final String? fromDate;
  final String? toDate;
  final double? minAmount;
  final double? maxAmount;
  final bool excludeIgnored;
  final bool uncategorized;

  bool get isEmpty =>
      accountIds.isEmpty &&
      categoryIds.isEmpty &&
      payeeId == null &&
      type == null &&
      status == null &&
      fromDate == null &&
      toDate == null &&
      minAmount == null &&
      maxAmount == null &&
      !excludeIgnored &&
      !uncategorized;

  /// How many distinct filter choices are active — shown as a badge count
  /// on the filter button, same idea as the web filter bar's chip row.
  int get activeCount => [
        if (accountIds.isNotEmpty) 1,
        if (categoryIds.isNotEmpty) 1,
        if (payeeId != null) 1,
        if (type != null) 1,
        if (status != null) 1,
        if (fromDate != null || toDate != null) 1,
        if (minAmount != null || maxAmount != null) 1,
        if (excludeIgnored) 1,
        if (uncategorized) 1,
      ].length;

  TransactionFilters copyWith({
    List<String>? accountIds,
    List<String>? categoryIds,
    String? payeeId,
    bool clearPayeeId = false,
    String? type,
    bool clearType = false,
    String? status,
    bool clearStatus = false,
    String? fromDate,
    bool clearFromDate = false,
    String? toDate,
    bool clearToDate = false,
    double? minAmount,
    bool clearMinAmount = false,
    double? maxAmount,
    bool clearMaxAmount = false,
    bool? excludeIgnored,
    bool? uncategorized,
  }) =>
      TransactionFilters(
        accountIds: accountIds ?? this.accountIds,
        categoryIds: categoryIds ?? this.categoryIds,
        payeeId: clearPayeeId ? null : (payeeId ?? this.payeeId),
        type: clearType ? null : (type ?? this.type),
        status: clearStatus ? null : (status ?? this.status),
        fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
        toDate: clearToDate ? null : (toDate ?? this.toDate),
        minAmount: clearMinAmount ? null : (minAmount ?? this.minAmount),
        maxAmount: clearMaxAmount ? null : (maxAmount ?? this.maxAmount),
        excludeIgnored: excludeIgnored ?? this.excludeIgnored,
        uncategorized: uncategorized ?? this.uncategorized,
      );

  Map<String, dynamic> toQuery() => {
        'account_ids': accountIds.isEmpty ? null : accountIds,
        'category_ids': categoryIds.isEmpty ? null : categoryIds,
        'payee_id': payeeId,
        'type': type,
        'status': status,
        'from': fromDate,
        'to': toDate,
        'min_amount': minAmount,
        'max_amount': maxAmount,
        'exclude_ignored': excludeIgnored ? true : null,
        'uncategorized': uncategorized ? true : null,
      };
}

class TransactionsRepository {
  TransactionsRepository(this._api);

  final ApiClient _api;

  Future<TransactionsPage> list({
    int page = 1,
    int limit = 30,
    String? query,
    String? accountId,
    TransactionFilters filters = const TransactionFilters(),
  }) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/transactions',
      query: {
        'page': page,
        'limit': limit,
        if (query != null && query.isNotEmpty) 'q': query,
        'account_id': ?accountId,
        ...filters.toQuery(),
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

  Future<Transaction> toggleIgnore(String id) async {
    final data = await _api.patch<Map<String, dynamic>>('/transactions/$id/ignore');
    return Transaction.fromJson(data);
  }

  Future<Transaction> unlinkRecurring(String id) async {
    final data = await _api.patch<Map<String, dynamic>>('/transactions/$id/unlink-recurring');
    return Transaction.fromJson(data);
  }

  /// Creates a new transaction copying every user-entered field from
  /// [source] except its date, which defaults to today — matching the
  /// web app's "duplicate" action (a new row, not a reference to the old
  /// one, so it carries none of the original's status/attachments/splits).
  Future<Transaction> duplicate(Transaction source, {String? date}) => create(
        description: source.description,
        amount: source.amount.abs(),
        date: date ?? DateTime.now().toIso8601String().split('T').first,
        type: source.type == TransactionType.credit ? 'credit' : 'debit',
        accountId: source.accountId!,
        categoryId: source.categoryId,
        payeeId: source.payeeId,
        currency: source.currency,
        notes: source.notes,
      );

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
