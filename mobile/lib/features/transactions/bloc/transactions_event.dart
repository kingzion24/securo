part of 'transactions_bloc.dart';

sealed class TransactionsEvent {
  const TransactionsEvent();
}

class TransactionsRequested extends TransactionsEvent {
  const TransactionsRequested();
}

class TransactionsRefreshed extends TransactionsEvent {
  const TransactionsRefreshed();
}

/// Fired when the list scrolls near its end; a no-op while a page is already
/// in flight or none remain, so a fast fling can't fire it twice.
class TransactionsMoreRequested extends TransactionsEvent {
  const TransactionsMoreRequested();
}

class TransactionsSearched extends TransactionsEvent {
  const TransactionsSearched(this.query);
  final String query;
}
