import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/chart_point_model.dart';
import 'dashboard_colors.dart';

class StudyBarChart extends StatelessWidget {
  final List<ChartPointModel> pts;
  final int? touchedIndex;
  final ValueChanged<int?> onTouch;

  const StudyBarChart({
    super.key,
    required this.pts,
    required this.touchedIndex,
    required this.onTouch,
  });

  static const double yMax = 12.0;

  @override
  Widget build(BuildContext context) {
    // Subsample labels: only show label every N bars
    final n = pts.length;

    return BarChart(
      BarChartData(
        maxY: yMax,
        minY: 0,
        groupsSpace: n > 30 ? 2 : 4,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF1E1B4B),
            tooltipBorderRadius: BorderRadius.circular(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final p = pts[groupIndex];
              return BarTooltipItem(
                '${p.label}\n',
                const TextStyle(
                  color: Colors.white60, fontSize: 10,
                ),
                children: [
                  TextSpan(
                    text: '${p.hours.toStringAsFixed(1)}h',
                    style: TextStyle(
                      color: p.isGain ? DashboardColors.gain : DashboardColors.loss,
                      fontSize: 13, fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: '\nMA7 · ${p.ma7.toStringAsFixed(1)}h',
                    style: const TextStyle(color: Color(0xFF4ECDB7), fontSize: 10),
                  ),
                ],
              );
            },
          ),
          touchCallback: (event, response) {
            if (event is FlTapUpEvent || event is FlPointerHoverEvent) {
              onTouch(response?.spot?.touchedBarGroupIndex);
            }
            if (event is FlPointerExitEvent) onTouch(null);
          },
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 2,
              getTitlesWidget: (v, meta) {
                if (v % 2 != 0) return const SizedBox.shrink();
                return Text(
                  v == 0 ? '0' : '${v.toInt()}h',
                  style: const TextStyle(fontSize: 9, color: DashboardColors.textSub),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 18,
              getTitlesWidget: (v, meta) {
                final i = v.toInt();
                if (i < 0 || i >= pts.length) return const SizedBox.shrink();
                final label = pts[i].shortLabel;
                if (label.isEmpty) return const SizedBox.shrink();
                return Text(
                  label,
                  style: const TextStyle(fontSize: 9, color: DashboardColors.textSub),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (v) => FlLine(
            color: const Color(0xFFEDE9FE),
            strokeWidth: 0.8,
            dashArray: [4, 6],
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: pts.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          final isTouched = touchedIndex == i;
          final h = p.hours.clamp(0.0, yMax);

          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: h,
                width: n > 30 ? 4 : 7,
                borderRadius: BorderRadius.circular(n > 30 ? 2 : 3),
                color: p.isGain
                    ? DashboardColors.gain.withOpacity(isTouched ? 1.0 : 0.55)
                    : DashboardColors.loss.withOpacity(isTouched ? 1.0 : 0.55),
              ),
            ],
            showingTooltipIndicators: isTouched ? [0] : [],
          );
        }).toList(),
        // ── MA7 line overlay via extraLinesData ──
        extraLinesData: ExtraLinesData(
          extraLinesOnTop: true,
          horizontalLines: [],
        ),
      ),
    );
  }
}
