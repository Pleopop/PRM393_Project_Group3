import '../../../core/api/api_client.dart';
import '../models/overview_model.dart';

bool isMockAPI = false;

class DashboardService {
  final _api = ApiClient().dio;

  Future<OverviewModel> fetchOverview() async {
    if (isMockAPI) {
      await Future.delayed(const Duration(milliseconds: 300));
      return OverviewModel.fromJson(_buildMockOverviewPayload());
    }

    final response = await _api.get('/api/dashboard/me');
    final data = response.data as Map<String, dynamic>;
    return OverviewModel.fromJson(data);
  }
}

Map<String, dynamic> _buildMockOverviewPayload() {
  final now = DateTime.now();
  final weekHours = [
    1.5, 2.0, 2.4, 1.8, 3.0, 2.6, 3.2, 2.1, 2.8, 3.4, 2.9, 3.6, 3.1, 2.7,
  ];
  final monthHours = [
    1.2, 1.8, 2.0, 1.5, 2.4, 2.7, 2.1, 1.9, 2.6, 2.8, 3.0, 2.2, 2.5, 2.9, 3.1,
    2.6, 2.4, 2.0, 2.7, 3.2, 3.4, 2.8, 2.5, 2.9, 3.3, 3.0, 2.7, 2.4, 2.8, 3.1,
  ];

  final streakDays = List.generate(30, (index) {
    final date = DateTime(now.year, now.month, index + 1);
    final hasStudy = index % 3 != 0 || index >= 20;
    return {
      'date': date.toIso8601String().split('T').first,
      'label': const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'][index % 7],
      'hasStudy': hasStudy,
      'isToday': date.day == now.day,
    };
  });

  final weeklyChart = List.generate(14, (i) {
    final day = 14 + (i ~/ 2);
    final isFirstHalf = i.isEven;
    final hours = weekHours[i];
    final prev = i > 0 ? weekHours[i - 1] : hours;
    return {
      'id': 'wh$i',
      'label': 'T${(i % 7) + 2} $day/4 · ${isFirstHalf ? '00-12' : '12-24'}',
      'shortLabel': isFirstHalf ? 'T${(i % 7) + 2}' : '',
      'hours': hours,
      'open': prev,
      'close': hours,
      'high': hours + 0.4,
      'low': hours > 0.4 ? hours - 0.4 : 0,
      'ma7': weekHours
              .sublist(i < 6 ? 0 : i - 6, i + 1)
              .reduce((a, b) => a + b) /
          (i < 6 ? i + 1 : 7),
      'isGain': hours >= prev,
      'change': prev == 0 ? 0 : ((hours - prev) / prev) * 100,
      'volume': (hours * 120).round(),
    };
  });

  final monthlyChart = List.generate(30, (i) {
    final hours = monthHours[i];
    final prev = i > 0 ? monthHours[i - 1] : hours;
    return {
      'id': 'md${i + 1}',
      'label': '${i + 1}/4',
      'shortLabel': (i + 1) % 5 == 1 ? '${i + 1}' : '',
      'hours': hours,
      'open': prev,
      'close': hours,
      'high': hours + 0.5,
      'low': hours > 0.5 ? hours - 0.5 : 0,
      'ma7': monthHours
              .sublist(i < 6 ? 0 : i - 6, i + 1)
              .reduce((a, b) => a + b) /
          (i < 6 ? i + 1 : 7),
      'isGain': hours >= prev,
      'change': prev == 0 ? 0 : ((hours - prev) / prev) * 100,
      'volume': (hours * 150).round(),
    };
  });

  final dailyTotals = List.generate(20, (i) {
    final date = now.subtract(Duration(days: 19 - i));
    return {
      'userId': 719418334088527922,
      'date': date.toIso8601String().split('T').first,
      'dayLabel': const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'][i % 7],
      'seconds': (monthHours[(10 + i) % monthHours.length] * 3600).round(),
    };
  });

  return {
    'stats': [
      {
        'id': 'totalHours',
        'label': 'TONG GIO HOC',
        'labelVi': 'Tuần này',
        'value': '24.1',
        'rawValue': 24.1,
        'change': 12.5,
        'trend': 'up',
        'suffix': 'H',
        'icon': 'Activity',
      },
      {
        'id': 'weekAvg',
        'label': 'TB/TUAN',
        'labelVi': 'Trung bình ngày (đến hôm nay)',
        'value': '3.4',
        'rawValue': 3.4,
        'change': 8.7,
        'trend': 'up',
        'suffix': 'H',
        'icon': 'BarChart',
      },
      {
        'id': 'avg',
        'label': 'DINH NGAY',
        'labelVi': 'Đỉnh ngày trong tuần',
        'value': '5.2',
        'rawValue': 5.2,
        'change': 4.2,
        'trend': 'up',
        'suffix': 'H',
        'icon': 'TrendingUp',
      },
      {
        'id': 'peak',
        'label': 'STREAK',
        'labelVi': 'Streak hiện tại',
        'value': '9',
        'rawValue': 9,
        'change': 1,
        'trend': 'up',
        'suffix': 'NGAY',
        'icon': 'Flame',
      },
      {
        'id': 'rank',
        'label': 'XEP HANG',
        'labelVi': 'Xếp hạng',
        'value': '#18',
        'rawValue': 18,
        'change': 2,
        'trend': 'up',
        'suffix': '',
        'icon': 'Target',
      },
      {
        'id': 'goal',
        'label': 'MUC TIEU',
        'labelVi': 'Mục tiêu',
        'value': '80',
        'rawValue': 80,
        'change': 6.5,
        'trend': 'up',
        'suffix': '%',
        'icon': 'Clock',
      },
    ],
    'weeklyChart': weeklyChart,
    'monthlyChart': monthlyChart,
    'timeOfDayHours': [14.5, 21.2, 30.4, 7.6],
    'streakCalendar': {
      'currentStreak': 9,
      'longestStreak': 21,
      'studyDays': streakDays.where((d) => d['hasStudy'] == true).length,
      'days': streakDays,
    },
    'basicStatistic': {
      'userId': 719418334088527922,
      'warningTime': 1200,
      'totalStudySeconds': 268740,
      'totalActiveDays': 87,
      'lastActiveAt': now.toIso8601String(),
      'secondsPerDay': 1800,
      'daysPerWeek': 4,
      'currentStreak': 9,
      'longestStreak': 21,
    },
    'dailyTotals': dailyTotals,
    'hourlyStudyRecords': <Map<String, dynamic>>[],
  };
}
