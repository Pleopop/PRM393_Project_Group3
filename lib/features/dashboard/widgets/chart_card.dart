import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/chart_point_model.dart';
import 'dashboard_colors.dart';
import 'study_bar_chart.dart';
import 'timeframe_toggle.dart';

class ChartCard extends StatefulWidget {
  final List<ChartPointModel> chart;
  final String timeframe;
  final ValueChanged<String> onToggle;

  const ChartCard({
    super.key,
    required this.chart,
    required this.timeframe,
    required this.onToggle,
  });

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  int? _touchedIndex;

  List<ChartPointModel> get pts => widget.chart;

  // ── Footer stats ──────────────────────────────────────────────────────────
  List<Map<String, String>> get _footerStats {
    final hours = pts.map((p) => p.hours).toList();
    if (hours.isEmpty) return [];

    final start = hours.first;
    final end = hours.last;
    final high = hours.reduce(math.max);
    final low = hours.reduce(math.min);
    final avg = hours.reduce((a, b) => a + b) / hours.length;
    final growth = start == 0 ? 0.0 : ((end - start) / start * 100);

    return [
      {'label': 'Đầu kỳ',   'value': '${start.toStringAsFixed(1)}h'},
      {'label': 'Cao nhất', 'value': '${high.toStringAsFixed(1)}h'},
      {'label': 'Thấp nhất','value': '${low.toStringAsFixed(1)}h'},
      {'label': 'Hiện tại', 'value': '${end.toStringAsFixed(1)}h'},
      {'label': 'Trung bình','value': '${avg.toStringAsFixed(1)}h'},
      {'label': 'Tăng trưởng','value': '${growth.toStringAsFixed(1)}%'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DashboardColors.border),
        boxShadow: [
          BoxShadow(
            color: DashboardColors.primary.withOpacity(0.06),
            blurRadius: 12, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tiến trình học tập',
                    style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: DashboardColors.textMain,
                    ),
                  ),
                  Text(
                    widget.timeframe == 'month'
                        ? '30 ngày gần nhất'
                        : '52 tuần gần nhất',
                    style: const TextStyle(fontSize: 11, color: DashboardColors.textSub),
                  ),
                ],
              ),
              TimeframeToggle(
                value: widget.timeframe,
                onChanged: widget.onToggle,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Chart ──
          SizedBox(
            height: 220,
            child: StudyBarChart(
              pts: pts,
              touchedIndex: _touchedIndex,
              onTouch: (i) => setState(() => _touchedIndex = i),
            ),
          ),

          // ── Footer grid ──
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: DashboardColors.primary.withOpacity(0.1)),
              ),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3.2,
              ),
              itemCount: _footerStats.length,
              itemBuilder: (_, i) {
                final f = _footerStats[i];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(f['value']!,
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: DashboardColors.textMain,
                      ),
                    ),
                    Text(f['label']!,
                      style: const TextStyle(
                        fontSize: 9, color: DashboardColors.textSub,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
