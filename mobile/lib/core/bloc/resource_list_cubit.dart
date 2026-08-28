import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';

enum ResourceListStatus { loading, refreshing, success, failure }

@immutable
class ResourceListState<T> {
  const ResourceListState({
    this.status = ResourceListStatus.loading,
    this.items = const [],
    this.error,
  });

  final ResourceListStatus status;
  final List<T> items;
  final String? error;

  ResourceListState<T> copyWith({
    ResourceListStatus? status,
    List<T>? items,
    String? error,
    bool clearError = false,
  }) =>
      ResourceListState<T>(
        status: status ?? this.status,
        items: items ?? this.items,
        error: clearError ? null : (error ?? this.error),
      );
}

/// Fetch-a-list-and-show-it is most of what the smaller drawer features
/// need — budgets, goals, categories, payees, and the rest. Rather than a
/// bespoke Bloc (events, states, part files) for each, this one generic
/// Cubit covers the shape; a screen that grows real interactions (drag to
/// reorder, optimistic edits) can graduate to its own Bloc later without
/// touching anyone else's.
class ResourceListCubit<T> extends Cubit<ResourceListState<T>> {
  ResourceListCubit(this._fetch) : super(const ResourceListState()) {
    load();
  }

  final Future<List<T>> Function() _fetch;

  Future<void> load() async {
    emit(state.copyWith(status: ResourceListStatus.loading, clearError: true));
    await _run();
  }

  Future<void> refresh() async {
    emit(state.copyWith(
      status: ResourceListStatus.refreshing,
      clearError: true,
    ));
    await _run();
  }

  Future<void> _run() async {
    try {
      final items = await _fetch();
      emit(state.copyWith(status: ResourceListStatus.success, items: items));
    } on ApiException catch (error) {
      emit(state.copyWith(
        status: ResourceListStatus.failure,
        error: error.message,
      ));
    } catch (error) {
      emit(state.copyWith(status: ResourceListStatus.failure, error: '$error'));
    }
  }
}
