import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/overview_model.dart';
import '../models/stat_model.dart';
import '../models/chart_point_model.dart';

class DashboardService {
  Future<OverviewModel> fetchOverview() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final rng = math.Random(42);

    // Generate 30-day chart
    final monthly = <ChartPointModel>[];
    double prev = 3.2;
    final List<double> raw = [];
    for (int i = 0; i < 30; i++) {
      final h = (prev + (rng.nextDouble() * 4 - 2)).clamp(1.0, 11.5);
      raw.add(h);
      prev = h;
    }
    // MA7
    for (int i = 0; i < raw.length; i++) {
      final start = math.max(0, i - 6);
      final ma = raw.sublist(start, i + 1).reduce((a, b) => a + b) /
          (i - start + 1);
      final chg = i == 0 ? 0.0 : (raw[i] - raw[i - 1]) / raw[i - 1] * 100;
      monthly.add(ChartPointModel(
        label: 'Ngày ${i + 1}',
        shortLabel: (i + 1) % 5 == 1 ? '${i + 1}' : '',
        hours: raw[i],
        ma7: ma,
        isGain: raw[i] >= (i > 0 ? raw[i - 1] : raw[i]),
        change: chg,
      ));
    }

    // Generate 52-week chart
    final yearly = <ChartPointModel>[];
    double prevW = 28.0;
    final List<double> rawW = [];
    for (int i = 0; i < 52; i++) {
      final h = (prevW + (rng.nextDouble() * 14 - 7)).clamp(5.0, 84.0);
      rawW.add(h);
      prevW = h;
    }
    for (int i = 0; i < rawW.length; i++) {
      final start = math.max(0, i - 6);
      final ma = rawW.sublist(start, i + 1).reduce((a, b) => a + b) /
          (i - start + 1);
      final chg = i == 0 ? 0.0 : (rawW[i] - rawW[i - 1]) / rawW[i - 1] * 100;
      yearly.add(ChartPointModel(
        label: 'Tuần ${i + 1}',
        shortLabel: (i + 1) % 13 == 1 ? 'T${(i ~/ 13) + 1}' : '',
        hours: rawW[i] / 7, // normalize to daily avg
        ma7: ma / 7,
        isGain: rawW[i] >= (i > 0 ? rawW[i - 1] : rawW[i]),
        change: chg,
      ));
    }

    return OverviewModel(
      stats: const [
        StatModel(
          id: 'total',
          labelVi: 'Tổng giờ học',
          rawValue: 20.6,
          suffix: 'H',
          trend: 'up',
          change: 55.6,
          icon: Icons.access_time_rounded,
        ),
        StatModel(
          id: 'today',
          labelVi: 'Hôm nay',
          rawValue: 3.1,
          suffix: 'H',
          trend: 'down',
          change: 22.2,
          icon: Icons.local_fire_department_rounded,
        ),
        StatModel(
          id: 'peak',
          labelVi: 'Đỉnh tuần',
          rawValue: 4.0,
          suffix: 'H',
          trend: 'up',
          change: 12.5,
          icon: Icons.trending_up_rounded,
        ),
        StatModel(
          id: 'rank',
          labelVi: 'Xếp hạng',
          rawValue: 15,
          suffix: '',
          trend: 'up',
          change: 1.0,
          icon: Icons.emoji_events_rounded,
        ),
        StatModel(
          id: 'goal',
          labelVi: 'Mục tiêu',
          rawValue: 104,
          suffix: '%',
          trend: 'up',
          change: 4.0,
          icon: Icons.track_changes_rounded,
        ),
      ],
      monthlyChart: monthly,
      yearlyChart: yearly,
    );
  }
}
