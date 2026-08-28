part of 'reports_bloc.dart';

enum ReportsStatus { loading, success, failure }

@immutable
class ReportsState {
  const ReportsState({
    this.kind = ReportKind.netWorth,
    this.status = ReportsStatus.loading,
    this.report,
    this.error,
  });

  final ReportKind kind;
  final ReportsStatus status;
  final Report? report;
  final String? error;

  ReportsState copyWith({
    ReportKind? kind,
    ReportsStatus? status,
    Report? report,
    String? error,
    bool clearError = false,
  }) =>
      ReportsState(
        kind: kind ?? this.kind,
        status: status ?? this.status,
        report: report ?? this.report,
        error: clearError ? null : (error ?? this.error),
      );
}
