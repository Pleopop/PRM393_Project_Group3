part of '../right_col.dart';

class _StreakRaw {
  static const int current = 12;
  static const int best = 28;
}

const _segmentHours = [42, 28, 55, 15];
const _segmentNames = ['Sáng', 'Chiều', 'Tối', 'Đêm'];
const _segmentColors = [
  DashboardColors.loss,
  DashboardColors.secondary,
  DashboardColors.primary,
  DashboardColors.ma,
];

double _seededRand(int seed) {
  final x = math.sin(seed * 9301 + 49297) * 233280;
  return x - x.floorToDouble();
}

class _CalDay {
  final DateTime date;
  final int intensity;
  final bool isStreakDay;
  final bool isStreakStart;
  final bool isToday;

  const _CalDay({
    required this.date,
    required this.intensity,
    required this.isStreakDay,
    required this.isStreakStart,
    required this.isToday,
  });
}

List<_CalDay> _buildCalendar() {
  final base = DateTime(2026, 3, 2);
  return List.generate(35, (i) {
    final date = base.add(Duration(days: i));
    final isStreakDay = i >= 23;
    final isStreakStart = i == 23;
    int intensity = 0;
    if (isStreakDay) {
      final l = _seededRand(i + 77);
      intensity = l < 0.18 ? 1 : l < 0.45 ? 2 : l < 0.78 ? 3 : 4;
    } else {
      if (_seededRand(i) < 0.45 + (i / 35) * 0.3) {
        final l = _seededRand(i + 77);
        intensity = l < 0.18 ? 1 : l < 0.45 ? 2 : l < 0.78 ? 3 : 4;
      }
    }
    return _CalDay(
      date: date,
      intensity: intensity,
      isStreakDay: isStreakDay,
      isStreakStart: isStreakStart,
      isToday: i == 34,
    );
  });
}

final _calDays = _buildCalendar();
final _studyDays = _calDays.where((d) => d.intensity > 0).length;

const _p1 = DashboardColors.primary;
const _p2 = DashboardColors.secondary;
const _surface = DashboardColors.surface;
const _border = DashboardColors.border;
const _textMain = DashboardColors.textMain;
const _textSub = DashboardColors.textSub;
