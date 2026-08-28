import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_exception.dart';
import '../../../models/account.dart';
import '../accounts_repository.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc(this._repository) : super(const AccountsState()) {
    on<AccountsRequested>(_onRequested);
    on<AccountsRefreshed>(_onRefreshed);
    on<ClosedAccountsToggled>(_onClosedToggled);
  }

  final AccountsRepository _repository;

  Future<void> _onRequested(
    AccountsRequested event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true));
    await _fetch(emit);
  }

  Future<void> _onRefreshed(
    AccountsRefreshed event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(status: AccountsStatus.refreshing, clearError: true));
    await _fetch(emit);
  }

  Future<void> _onClosedToggled(
    ClosedAccountsToggled event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(
      includeClosed: !state.includeClosed,
      status: AccountsStatus.loading,
    ));
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<AccountsState> emit) async {
    try {
      final accounts =
          await _repository.list(includeClosed: state.includeClosed);
      emit(state.copyWith(
        status: AccountsStatus.success,
        accounts: accounts,
      ));
    } on ApiException catch (error) {
      emit(state.copyWith(
        status: AccountsStatus.failure,
        error: error.message,
      ));
    } catch (error) {
      emit(state.copyWith(status: AccountsStatus.failure, error: '$error'));
    }
  }
}
