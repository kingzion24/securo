part of 'transactions_bloc.dart';

enum TransactionsStatus { initial, loading, refreshing, loadingMore, success, failure }

@immutable
class TransactionsState {
  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.page = 1,
    this.hasMore = true,
    this.query = '',
    this.filters = const TransactionFilters(),
    this.error,
  });

  final TransactionsStatus status;
  final List<Transaction> transactions;
  final int page;
  final bool hasMore;
  final String query;
  final TransactionFilters filters;
  final String? error;

  /// Grouped by calendar date, newest first — the API already sorts that way,
  /// so this only has to bucket, not re-sort.
  Map<String, List<Transaction>> get groupedByDate {
    final groups = <String, List<Transaction>>{};
    for (final tx in transactions) {
      final day = tx.date.split('T').first;
      groups.putIfAbsent(day, () => []).add(tx);
    }
    return groups;
  }

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactions,
    int? page,
    bool? hasMore,
    String? query,
    TransactionFilters? filters,
    String? error,
    bool clearError = false,
  }) =>
      TransactionsState(
        status: status ?? this.status,
        transactions: transactions ?? this.transactions,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        query: query ?? this.query,
        filters: filters ?? this.filters,
        error: clearError ? null : (error ?? this.error),
      );
}
