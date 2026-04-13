import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:fitness/core/resources/AppStyles/AppStyles.dart';
import 'package:fitness/features/mainlayout/Progress/provider/Progressprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Progress extends StatelessWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context) {
    // Same pattern as ShowDoneTab and ShowTab:
    // ChangeNotifierProvider created right here in the widget
    return ChangeNotifierProvider(
      create: (context) => ChartProvider()..init(),
      builder: (context, child) {
        var provider = Provider.of<ChartProvider>(context);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Day Chart ──────────────────────────────────────────────────
              Text("Progress of Day", style: AppStyles.headers),
              const SizedBox(height: 4),
              Text(
                "Time (min) & calories per activity today",
                style: AppStyles.hintText,
              ),
              const SizedBox(height: 12),
              _ChartCard(
                child: provider.isLoadingDay
                    ? const _Loader()
                    : _DayChart(data: provider.dayChartData),
              ),

              const SizedBox(height: 28),

              // ── Week Chart ─────────────────────────────────────────────────
              Text("Progress of Week", style: AppStyles.headers),
              const SizedBox(height: 4),
              Text(
                "Total time & calories — last 7 days",
                style: AppStyles.hintText,
              ),
              const SizedBox(height: 12),
              _ChartCard(
                child: provider.isLoadingWeek
                    ? const _Loader()
                    : _WeekChart(data: provider.weekChartData),
              ),

              // Extra bottom padding so the last card clears the nav bar
              const SizedBox(height: 85),
            ],
          ),
        );
      },
    );
  }
}

// ─── Day Chart ─────────────────────────────────────────────────────────────────

class _DayChart extends StatelessWidget {
  final List<CategoryChartData> data;
  const _DayChart({required this.data});

  @override
  Widget build(BuildContext context) {
    // If every category is zero, show empty state
    final hasData = data.any((d) => d.totalTime > 0 || d.totalCal > 0);
    if (!hasData) return const _EmptyState();

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: const TextStyle(fontSize: 12),
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(fontSize: 10),
        labelRotation: -30,
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0.5),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        ColumnSeries<CategoryChartData, String>(
          name: 'Time (min)',
          dataSource: data,
          xValueMapper: (d, _) => _shortLabel(d.category),
          yValueMapper: (d, _) => d.totalTime,
          color: AppColors.myBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          spacing: 0.1,
        ),
        ColumnSeries<CategoryChartData, String>(
          name: 'Calories',
          dataSource: data,
          xValueMapper: (d, _) => _shortLabel(d.category),
          yValueMapper: (d, _) => d.totalCal,
          color: AppColors.myOrange,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          spacing: 0.1,
        ),
      ],
    );
  }

  // Shorter labels so they fit without heavy rotation on small screens
  String _shortLabel(String cat) {
    const map = {
      'Home Workout': 'Home',
      'Running': 'Run',
      'Walking': 'Walk',
      'Cycling': 'Cycle',
    };
    return map[cat] ?? cat;
  }
}

// ─── Week Chart ────────────────────────────────────────────────────────────────

class _WeekChart extends StatelessWidget {
  final List<DayChartData> data;
  const _WeekChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final hasData = data.any((d) => d.totalTime > 0 || d.totalCal > 0);
    if (!hasData) return const _EmptyState();

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: const TextStyle(fontSize: 12),
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(fontSize: 11),
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0.5),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        ColumnSeries<DayChartData, String>(
          name: 'Time (min)',
          dataSource: data,
          xValueMapper: (d, _) => d.dayLabel,
          yValueMapper: (d, _) => d.totalTime,
          color: AppColors.myGreen,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          spacing: 0.1,
        ),
        ColumnSeries<DayChartData, String>(
          name: 'Calories',
          dataSource: data,
          xValueMapper: (d, _) => d.dayLabel,
          yValueMapper: (d, _) => d.totalCal,
          color: AppColors.myOrange,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          spacing: 0.1,
        ),
      ],
    );
  }
}

// ─── Shared helpers ────────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final Widget child;
  const _ChartCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.myWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.myBlack),
      ),
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: child,
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(color: AppColors.myBlue, strokeWidth: 2),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.bar_chart_outlined, size: 48, color: AppColors.myGray1),
        const SizedBox(height: 8),
        Text("No activity recorded yet", style: AppStyles.hintText),
      ],
    ),
  );
}
