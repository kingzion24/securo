import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';

enum ResourceListStatus { loading, refreshing, success, failure }

@immutable
class ResourceListState<T> {
  // `items` is built in the initializer list rather than as a `= const []`
  // default, because a literal default value on a generic-typed parameter is
  // canonicalized once as `List<Never>` and shared across every
  // instantiation of this class — it then fails at runtime the moment a real
  // `List<T>` (e.g. from copyWith) has to coexist with it. Assigning here
  // instead binds the empty list to this specific T.
  const ResourceListState({
    this.status = ResourceListStatus.loading,
    List<T>? items,
    this.error,
  }) : items = items ?? const [];

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
  // Explicit `<T>` matters here: an un-parameterized `const ResourceListState()`
  // as a super-constructor argument left the type argument uninferred, and
  // Dart's const-canonicalization defaulted it to `Never` — the initial
  // state was silently `ResourceListState<Never>` regardless of what T
  // actually was, and the first real emit (a `List<T>` from `_fetch`) threw
  // a cast error.
  ResourceListCubit(this._fetch) : super(ResourceListState<T>()) {
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
