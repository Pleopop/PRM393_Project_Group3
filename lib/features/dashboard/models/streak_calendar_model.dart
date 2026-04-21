class StreakDayModel {
  final DateTime date;
  final String label;
  final bool hasStudy;
  final bool isToday;

  const StreakDayModel({
    required this.date,
    required this.label,
    required this.hasStudy,
    required this.isToday,
  });

  factory StreakDayModel.fromJson(Map<String, dynamic> json) {
    return StreakDayModel(
      date: DateTime.tryParse((json['date'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      label: (json['label'] ?? '').toString(),
      hasStudy: json['hasStudy'] == true,
      isToday: json['isToday'] == true,
    );
  }
}

class StreakCalendarModel {
  final int currentStreak;
  final int longestStreak;
  final int studyDays;
  final List<StreakDayModel> days;

  const StreakCalendarModel({
    required this.currentStreak,
    required this.longestStreak,
    required this.studyDays,
    required this.days,
  });

  factory StreakCalendarModel.fromJson(Map<String, dynamic> json) {
    final daysJson = (json['days'] as List<dynamic>? ?? const []);
    return StreakCalendarModel(
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      studyDays: (json['studyDays'] as num?)?.toInt() ?? 0,
      days: daysJson
          .whereType<Map<String, dynamic>>()
          .map(StreakDayModel.fromJson)
          .toList(),
    );
  }
}
