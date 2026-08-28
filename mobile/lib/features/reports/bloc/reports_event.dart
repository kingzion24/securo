part of 'reports_bloc.dart';

sealed class ReportsEvent {
  const ReportsEvent();
}

class ReportKindSelected extends ReportsEvent {
  const ReportKindSelected(this.kind);
  final ReportKind kind;
}

class ReportsRefreshed extends ReportsEvent {
  const ReportsRefreshed();
}
