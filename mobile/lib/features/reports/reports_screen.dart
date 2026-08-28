import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/color.dart';
import '../../core/format/money.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../models/report.dart';
import '../workspace/workspace_controller.dart';
import 'bloc/reports_bloc.dart';
import 'reports_repository.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => ReportsRepository(ref.watch(apiClientProvider)),
);

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(reportsRepositoryProvider);
    return BlocProvider(
      create: (_) => ReportsBloc(repository),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends ConsumerWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(currentWorkspaceProvider).valueOrNull?.locale;
    final state = context.watch<ReportsBloc>().state;

    return LargeTitleScrollView(
      title: 'Reports',
      onRefresh: () async {
        context.read<ReportsBloc>().add(const ReportsRefreshed());
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KindSelector(selected: state.kind),
                const SizedBox(height: 20),
                switch (state.status) {
                  ReportsStatus.loading => const _ReportSkeleton(),
                  ReportsStatus.failure => ErrorState(
                      message: state.error ?? 'Could not load this report',
                      onRetry: () => context
                          .read<ReportsBloc>()
                          .add(ReportKindSelected(state.kind)),
                    ),
                  ReportsStatus.success => _ReportBody(
                      report: state.report!,
                      locale: locale,
                    ),
                },
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The real iOS sliding segmented control, not a hand-rolled pill row — the
/// thumb glides between segments with the platform's own spring, not a
/// custom `AnimatedContainer` guess at one.
class _KindSelector extends StatelessWidget {
  const _KindSelector({required this.selected});

  final ReportKind selected;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return CupertinoSlidingSegmentedControl<ReportKind>(
      groupValue: selected,
      backgroundColor: colors.muted,
      thumbColor: colors.card,
      children: {
        for (final kind in ReportKind.values)
          kind: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              kind.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight:
                        kind == selected ? FontWeight.w700 : FontWeight.w500,
                    color: kind == selected
                        ? colors.foreground
                        : colors.mutedForeground,
                  ),
            ),
          ),
      },
      onValueChanged: (kind) {
        if (kind != null) {
          context.read<ReportsBloc>().add(ReportKindSelected(kind));
        }
      },
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report, this.locale});

  final Report report;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final summary = report.summary;
    final positive = summary.changeAmount >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatMoney(
            summary.primaryValue,
            currency: report.meta.currency,
            locale: locale,
          ),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // The arrow direction already says whether this went up or down;
            // a green/red on top of it would be the "color as status" trap
            // this UI otherwise avoids.
            Icon(
              positive ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: colors.mutedForeground,
            ),
            const SizedBox(width: 4),
            Text(
              '${formatMoney(summary.changeAmount.abs(), currency: report.meta.currency, locale: locale)}'
              '${summary.changePercent != null ? ' (${formatPercent(summary.changePercent!.abs(), locale: locale)})' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.mutedForeground,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SecuroCard(
          child: SizedBox(
            height: 200,
            child: report.trend.isEmpty
                ? const EmptyState(
                    icon: Icons.show_chart,
                    title: 'Not enough data yet',
                  )
                : _TrendChart(trend: report.trend),
          ),
        ),
        if (summary.breakdowns.isNotEmpty) ...[
          const SizedBox(height: 24),
          const SectionTitle('Breakdown'),
          SecuroCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < summary.breakdowns.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: colors.border),
                  _BreakdownRow(
                    breakdown: summary.breakdowns[i],
                    currency: report.meta.currency,
                    locale: locale,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.trend});

  final List<ReportDataPoint> trend;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final spots = [
      for (var i = 0; i < trend.length; i++)
        FlSpot(i.toDouble(), trend[i].value),
    ];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.2,
            color: colors.chart1,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.chart1.withValues(alpha: 0.18),
                  colors.chart1.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.breakdown,
    required this.currency,
    this.locale,
  });

  final ReportBreakdown breakdown;
  final String currency;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final color = parseHexColor(breakdown.color) ?? colors.chart2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              breakdown.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            formatMoney(breakdown.value, currency: currency, locale: locale),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ReportSkeleton extends StatelessWidget {
  const _ReportSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 160, height: 28),
          SizedBox(height: 10),
          ShimmerBox(width: 100, height: 14),
          SizedBox(height: 20),
          ShimmerBox(height: 200, radius: 16),
        ],
      );
}
