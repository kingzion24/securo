import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../core/api/api_exception.dart';
import '../../../models/transaction.dart';
import '../transactions_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc(this._repository) : super(const TransactionsState()) {
    on<TransactionsRequested>(_onRequested, transformer: restartable());
    on<TransactionsRefreshed>(_onRefreshed, transformer: restartable());
    on<TransactionsMoreRequested>(_onMoreRequested, transformer: droppable());
    on<TransactionsSearched>(
      _onSearched,
      transformer: _debounce(const Duration(milliseconds: 350)),
    );
    on<TransactionsFiltersChanged>(_onFiltersChanged, transformer: restartable());
  }

  final TransactionsRepository _repository;

  /// Exposed so a row's delete action doesn't need its own route to the
  /// repository — the bloc already holds one.
  Future<void> deleteTransaction(String id) => _repository.delete(id);

  Future<void> _onRequested(
    TransactionsRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading, clearError: true));
    await _load(page: 1, emit: emit, replace: true);
  }

  Future<void> _onRefreshed(
    TransactionsRefreshed event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(
      status: TransactionsStatus.refreshing,
      clearError: true,
    ));
    await _load(page: 1, emit: emit, replace: true);
  }

  Future<void> _onMoreRequested(
    TransactionsMoreRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    if (!state.hasMore || state.status == TransactionsStatus.loadingMore) {
      return;
    }
    emit(state.copyWith(status: TransactionsStatus.loadingMore));
    await _load(page: state.page + 1, emit: emit, replace: false);
  }

  Future<void> _onSearched(
    TransactionsSearched event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(
      query: event.query,
      status: TransactionsStatus.loading,
      clearError: true,
    ));
    await _load(page: 1, emit: emit, replace: true);
  }

  Future<void> _onFiltersChanged(
    TransactionsFiltersChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(
      filters: event.filters,
      status: TransactionsStatus.loading,
      clearError: true,
    ));
    await _load(page: 1, emit: emit, replace: true);
  }

  Future<void> _load({
    required int page,
    required Emitter<TransactionsState> emit,
    required bool replace,
  }) async {
    try {
      final result = await _repository.list(
        page: page,
        query: state.query,
        filters: state.filters,
      );
      emit(state.copyWith(
        status: TransactionsStatus.success,
        transactions:
            replace ? result.items : [...state.transactions, ...result.items],
        page: result.page,
        hasMore: result.hasMore,
      ));
    } on ApiException catch (error) {
      emit(state.copyWith(
        status: TransactionsStatus.failure,
        error: error.message,
      ));
    } catch (error) {
      emit(state.copyWith(status: TransactionsStatus.failure, error: '$error'));
    }
  }
}
