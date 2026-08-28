part of 'accounts_bloc.dart';

enum AccountsStatus { initial, loading, refreshing, success, failure }

@immutable
class AccountsState {
  const AccountsState({
    this.status = AccountsStatus.initial,
    this.accounts = const [],
    this.includeClosed = false,
    this.error,
  });

  final AccountsStatus status;
  final List<Account> accounts;
  final bool includeClosed;
  final String? error;

  double totalByType(String type) => accounts
      .where((a) => a.type == type && !a.isClosed)
      .fold(0, (sum, a) => sum + (a.balancePrimary ?? a.currentBalance));

  Map<String, List<Account>> get groupedByType {
    final groups = <String, List<Account>>{};
    for (final account in accounts) {
      groups.putIfAbsent(account.type, () => []).add(account);
    }
    return groups;
  }

  AccountsState copyWith({
    AccountsStatus? status,
    List<Account>? accounts,
    bool? includeClosed,
    String? error,
    bool clearError = false,
  }) =>
      AccountsState(
        status: status ?? this.status,
        accounts: accounts ?? this.accounts,
        includeClosed: includeClosed ?? this.includeClosed,
        error: clearError ? null : (error ?? this.error),
      );
}
