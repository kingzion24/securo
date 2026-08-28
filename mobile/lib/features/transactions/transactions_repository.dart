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
  }) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/transactions',
      query: {
        'page': page,
        'limit': limit,
        if (query != null && query.isNotEmpty) 'q': query,
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
}
