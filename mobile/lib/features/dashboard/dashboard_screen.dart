import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/money.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/panels.dart';
import '../../models/dashboard.dart';
import '../workspace/workspace_controller.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(currentWorkspaceProvider).valueOrNull;
    final locale = workspace?.locale;
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refresh(ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(ref),
        child: summaryAsync.when(
          loading: () => const _DashboardSkeleton(),
          error: (error, _) => ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ErrorState(
                message: '$error',
                onRetry: () => _refresh(ref),
              ),
            ],
          ),
          data: (summary) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              _SummaryGrid(summary: summary, locale: locale),
              const SizedBox(height: 24),
              const SectionTitle('Balance this month'),
              _BalanceChart(currency: summary.primaryCurrency, locale: locale),
              const SizedBox(height: 24),
              const SectionTitle('Spending by category'),
              _SpendingPanel(
                currency: summary.primaryCurrency,
                locale: locale,
              ),
              const SizedBox(height: 24),
              const SectionTitle('Income vs expenses'),
              _TrendChart(currency: summary.primaryCurrency, locale: locale),
            ],
          ),
        ),
      ),
    );
  }

  void _refresh(WidgetRef ref) {
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(spendingByCategoryProvider);
    ref.invalidate(monthlyTrendProvider);
    ref.invalidate(balanceHistoryProvider);
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary, this.locale});

  final DashboardSummary summary;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final currency = summary.primaryCurrency;

    final tiles = <Widget>[
      _StatTile(
        label: 'Total balance',
        value: formatMoney(
          summary.totalBalancePrimary,
          currency: currency,
          locale: locale,
        ),
        icon: Icons.account_balance_wallet_outlined,
        accent: colors.chart1,
        footnote: summary.balanceDate == null
            ? null
            : 'as of ${formatDayMonth(summary.balanceDate, locale: locale)}',
      ),
      _StatTile(
        label: 'Income this month',
        value: formatMoney(
          summary.monthlyIncomePrimary,
          currency: currency,
          locale: locale,
        ),
        icon: Icons.south_west,
        accent: colors.chart3,
      ),
      _StatTile(
        label: 'Expenses this month',
        value: formatMoney(
          summary.monthlyExpensesPrimary,
          currency: currency,
          locale: locale,
        ),
        icon: Icons.north_east,
        accent: colors.chart5,
      ),
      _StatTile(
        label: 'Invested assets',
        value: formatMoney(
          summary.assetsValuePrimary,
          currency: currency,
          locale: locale,
        ),
        icon: Icons.trending_up,
        accent: colors.chart2,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: tiles[0]),
            const SizedBox(width: 12),
            Expanded(child: tiles[1]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: tiles[2]),
            const SizedBox(width: 12),
            Expanded(child: tiles[3]),
          ],
        ),
        if (summary.pendingCategorization > 0) ...[
          const SizedBox(height: 12),
          _PendingBanner(summary: summary, locale: locale),
        ],
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    this.footnote,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;

    return SecuroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(SecuroRadius.sm),
                ),
                child: Icon(icon, size: 15, color: accent),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  style: text.labelSmall?.copyWith(
                    color: colors.mutedForeground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (footnote != null) ...[
            const SizedBox(height: 2),
            Text(
              footnote!,
              style: text.labelSmall?.copyWith(color: colors.mutedForeground),
            ),
          ],
        ],
      ),
    );
  }
}

class _PendingBanner extends StatelessWidget {
  const _PendingBanner({required this.summary, this.locale});

  final DashboardSummary summary;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final count = summary.pendingCategorization;

    return SecuroCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.label_outline, size: 18, color: colors.chart4),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count transaction${count == 1 ? '' : 's'} awaiting a category '
              '(${formatMoney(summary.pendingCategorizationAmount, currency: summary.primaryCurrency, locale: locale)})',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingPanel extends ConsumerWidget {
  const _SpendingPanel({required this.currency, this.locale});

  final String currency;
  final String? locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = SecuroTheme.of(context);
    final async = ref.watch(spendingByCategoryProvider);

    return SecuroCard(
      child: async.when(
        loading: () => const _RowsSkeleton(rows: 4),
        error: (error, _) => SizedBox(
          height: 120,
          child: ErrorState(
            message: '$error',
            onRetry: () => ref.invalidate(spendingByCategoryProvider),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const SizedBox(
              height: 120,
              child: EmptyState(
                icon: Icons.pie_chart_outline,
                title: 'No spending yet',
                message: 'Categorised expenses will show up here.',
              ),
            );
          }

          final top = items.take(6).toList();
          return Column(
            children: [
              SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 44,
                    sections: [
                      for (var i = 0; i < top.length; i++)
                        PieChartSectionData(
                          value: top[i].total.abs(),
                          color: _categoryColor(top[i], i, colors),
                          radius: 22,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < top.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                _LegendRow(
                  color: _categoryColor(top[i], i, colors),
                  label: top[i].categoryName,
                  amount: formatMoney(
                    top[i].total,
                    currency: currency,
                    locale: locale,
                  ),
                  percentage: top[i].percentage,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Categories carry their own colour from the server; the chart palette is
  /// the fallback so an uncoloured category still reads distinctly.
  Color _categoryColor(SpendingByCategory item, int index, SecuroColors colors) {
    final raw = item.categoryColor.replaceFirst('#', '');
    if (raw.length == 6) {
      final value = int.tryParse(raw, radix: 16);
      if (value != null) return Color(0xFF000000 | value);
    }
    return colors.chartPalette[index % colors.chartPalette.length];
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.amount,
    required this.percentage,
  });

  final Color color;
  final String label;
  final String amount;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall,
          ),
        ),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: text.labelSmall?.copyWith(color: colors.mutedForeground),
        ),
        const SizedBox(width: 10),
        Text(
          amount,
          style: text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _BalanceChart extends ConsumerWidget {
  const _BalanceChart({required this.currency, this.locale});

  final String currency;
  final String? locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = SecuroTheme.of(context);
    final async = ref.watch(balanceHistoryProvider);

    return SecuroCard(
      child: SizedBox(
        height: 170,
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorState(
            message: '$error',
            onRetry: () => ref.invalidate(balanceHistoryProvider),
          ),
          data: (history) {
            final current = history.current
                .where((d) => d.balance != null)
                .toList();
            if (current.isEmpty) {
              return const EmptyState(
                icon: Icons.show_chart,
                title: 'No balance history',
                message: 'Balances appear once there are transactions.',
              );
            }

            final previous =
                history.previous.where((d) => d.balance != null).toList();

            return LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: colors.border, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 7,
                      reservedSize: 22,
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colors.mutedForeground,
                            ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots
                        .map(
                          (spot) => LineTooltipItem(
                            formatMoney(
                              spot.y,
                              currency: currency,
                              locale: locale,
                              compact: true,
                            ),
                            TextStyle(
                              color: colors.foreground,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                lineBarsData: [
                  // Last month sits behind as a dashed reference line, the way
                  // the web chart draws it.
                  if (previous.isNotEmpty)
                    LineChartBarData(
                      spots: [
                        for (final d in previous)
                          FlSpot(d.day.toDouble(), d.balance!),
                      ],
                      isCurved: true,
                      barWidth: 1.5,
                      color: colors.mutedForeground.withValues(alpha: 0.45),
                      dashArray: const [4, 4],
                      dotData: const FlDotData(show: false),
                    ),
                  LineChartBarData(
                    spots: [
                      for (final d in current)
                        FlSpot(d.day.toDouble(), d.balance!),
                    ],
                    isCurved: true,
                    barWidth: 2.5,
                    color: colors.chart1,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: colors.chart1.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TrendChart extends ConsumerWidget {
  const _TrendChart({required this.currency, this.locale});

  final String currency;
  final String? locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = SecuroTheme.of(context);
    final async = ref.watch(monthlyTrendProvider);

    return SecuroCard(
      child: SizedBox(
        height: 190,
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorState(
            message: '$error',
            onRetry: () => ref.invalidate(monthlyTrendProvider),
          ),
          data: (months) {
            if (months.isEmpty) {
              return const EmptyState(
                icon: Icons.bar_chart_outlined,
                title: 'Nothing to compare yet',
                message: 'Income and expenses appear here month by month.',
              );
            }

            final maxValue = months
                .expand((m) => [m.income, m.expenses])
                .fold<double>(0, (a, b) => b > a ? b : a);

            return BarChart(
              BarChartData(
                maxY: maxValue == 0 ? 1 : maxValue * 1.15,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: colors.border, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index < 0 || index >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            formatMonthLabel(
                              months[index].month,
                              locale: locale,
                            ).split(' ').first,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: colors.mutedForeground),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                      formatMoney(
                        rod.toY,
                        currency: currency,
                        locale: locale,
                        compact: true,
                      ),
                      TextStyle(
                        color: colors.foreground,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < months.length; i++)
                    BarChartGroupData(
                      x: i,
                      barsSpace: 3,
                      barRods: [
                        BarChartRodData(
                          toY: months[i].income,
                          color: colors.chart3,
                          width: 7,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        BarChartRodData(
                          toY: months[i].expenses,
                          color: colors.chart5,
                          width: 7,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RowsSkeleton extends StatelessWidget {
  const _RowsSkeleton({required this.rows});
  final int rows;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (var i = 0; i < rows; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            Row(
              children: [
                const ShimmerBox(height: 10, width: 10, radius: 5),
                const SizedBox(width: 10),
                Expanded(child: ShimmerBox(height: 10, width: 80)),
                const SizedBox(width: 10),
                const ShimmerBox(height: 10, width: 54),
              ],
            ),
          ],
        ],
      );
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          for (var row = 0; row < 2; row++) ...[
            if (row > 0) const SizedBox(height: 12),
            Row(
              children: [
                for (var col = 0; col < 2; col++) ...[
                  if (col > 0) const SizedBox(width: 12),
                  const Expanded(
                    child: SecuroCard(child: ShimmerBox(height: 56)),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: 24),
          const SecuroCard(child: ShimmerBox(height: 150)),
          const SizedBox(height: 24),
          const SecuroCard(child: ShimmerBox(height: 150)),
        ],
      );
}
