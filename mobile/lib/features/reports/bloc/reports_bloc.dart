import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_exception.dart';
import '../../../models/report.dart';
import '../reports_repository.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc(this._repository) : super(const ReportsState()) {
    on<ReportKindSelected>(_onKindSelected, transformer: restartable());
    on<ReportsRefreshed>(_onRefreshed, transformer: restartable());
    add(ReportKindSelected(state.kind));
  }

  final ReportsRepository _repository;

  Future<void> _onKindSelected(
    ReportKindSelected event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(
      kind: event.kind,
      status: ReportsStatus.loading,
      clearError: true,
    ));
    await _fetch(event.kind, emit);
  }

  Future<void> _onRefreshed(
    ReportsRefreshed event,
    Emitter<ReportsState> emit,
  ) async {
    await _fetch(state.kind, emit);
  }

  Future<void> _fetch(ReportKind kind, Emitter<ReportsState> emit) async {
    try {
      final report = await _repository.fetch(kind);
      emit(state.copyWith(status: ReportsStatus.success, report: report));
    } on ApiException catch (error) {
      emit(state.copyWith(status: ReportsStatus.failure, error: error.message));
    } catch (error) {
      emit(state.copyWith(status: ReportsStatus.failure, error: '$error'));
    }
  }
}
