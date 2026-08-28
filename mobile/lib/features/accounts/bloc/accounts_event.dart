part of 'accounts_bloc.dart';

sealed class AccountsEvent {
  const AccountsEvent();
}

class AccountsRequested extends AccountsEvent {
  const AccountsRequested();
}

/// Pull-to-refresh: same fetch, but the bloc keeps the current list on
/// screen while it runs instead of showing a full loading state.
class AccountsRefreshed extends AccountsEvent {
  const AccountsRefreshed();
}

class ClosedAccountsToggled extends AccountsEvent {
  const ClosedAccountsToggled();
}
