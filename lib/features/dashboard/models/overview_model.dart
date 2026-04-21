import 'package:flutter/material.dart';
import 'stat_model.dart';
import 'chart_point_model.dart';
import 'streak_calendar_model.dart';
import 'basic_statistic_model.dart';
import 'daily_total_model.dart';

class OverviewModel {
  final List<StatModel> stats;
  final List<ChartPointModel> weeklyChart;
  final List<ChartPointModel> monthlyChart;
  final List<double> timeOfDayHours;
  final StreakCalendarModel streakCalendar;
  final BasicStatisticModel basicStatistic;
  final List<DailyTotalModel> dailyTotals;
  final List<Map<String, dynamic>> hourlyStudyRecords;

  const OverviewModel({
    required this.stats,
    required this.weeklyChart,
    required this.monthlyChart,
    required this.timeOfDayHours,
    required this.streakCalendar,
    required this.basicStatistic,
    required this.dailyTotals,
    required this.hourlyStudyRecords,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    final statsJson = (json['stats'] as List<dynamic>? ?? const []);
    final weeklyJson = (json['weeklyChart'] as List<dynamic>? ?? const []);
    final monthlyJson = (json['monthlyChart'] as List<dynamic>? ?? const []);
    final timeOfDayJson = (json['timeOfDayHours'] as List<dynamic>? ?? const []);
    final dailyTotalsJson = (json['dailyTotals'] as List<dynamic>? ?? const []);
    final hourlyRecords = (json['hourlyStudyRecords'] as List<dynamic>? ?? const []);

    return OverviewModel(
      stats: statsJson
          .whereType<Map<String, dynamic>>()
          .map(StatModelMapper.fromJson)
          .toList(),
      weeklyChart: weeklyJson
          .whereType<Map<String, dynamic>>()
          .map(ChartPointModel.fromJson)
          .toList(),
      monthlyChart: monthlyJson
          .whereType<Map<String, dynamic>>()
          .map(ChartPointModel.fromJson)
          .toList(),
      timeOfDayHours: timeOfDayJson
          .map((e) => e is num ? e.toDouble() : double.tryParse(e.toString()) ?? 0)
          .toList(),
      streakCalendar: StreakCalendarModel.fromJson(
        (json['streakCalendar'] as Map<String, dynamic>?) ?? const {},
      ),
      basicStatistic: BasicStatisticModel.fromJson(
        (json['basicStatistic'] as Map<String, dynamic>?) ?? const {},
      ),
      dailyTotals: dailyTotalsJson
          .whereType<Map<String, dynamic>>()
          .map(DailyTotalModel.fromJson)
          .toList(),
      hourlyStudyRecords: hourlyRecords
          .whereType<Map<String, dynamic>>()
          .toList(growable: false),
    );
  }
}

class StatModelMapper {
  static StatModel fromJson(Map<String, dynamic> json) {
    return StatModel(
      id: (json['id'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      labelVi: (json['labelVi'] ?? '').toString(),
      value: (json['value'] ?? '').toString(),
      rawValue: _toDouble(json['rawValue']),
      change: _toDouble(json['change']),
      trend: (json['trend'] ?? 'flat').toString(),
      suffix: (json['suffix'] ?? '').toString(),
      icon: _mapIcon((json['icon'] ?? '').toString()),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'Activity':
        return Icons.access_time_rounded;
      case 'BarChart':
        return Icons.bar_chart_rounded;
      case 'TrendingUp':
        return Icons.trending_up_rounded;
      case 'Flame':
        return Icons.local_fire_department_rounded;
      case 'Target':
        return Icons.emoji_events_rounded;
      case 'Clock':
        return Icons.track_changes_rounded;
      default:
        return Icons.analytics_rounded;
    }
  }
}
