class BasicStatisticModel {
  final int userId;
  final int warningTime;
  final int totalStudySeconds;
  final int totalActiveDays;
  final DateTime? lastActiveAt;
  final int secondsPerDay;
  final int daysPerWeek;
  final int currentStreak;
  final int longestStreak;

  const BasicStatisticModel({
    required this.userId,
    required this.warningTime,
    required this.totalStudySeconds,
    required this.totalActiveDays,
    required this.lastActiveAt,
    required this.secondsPerDay,
    required this.daysPerWeek,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory BasicStatisticModel.fromJson(Map<String, dynamic> json) {
    return BasicStatisticModel(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      warningTime: (json['warningTime'] as num?)?.toInt() ?? 0,
      totalStudySeconds: (json['totalStudySeconds'] as num?)?.toInt() ?? 0,
      totalActiveDays: (json['totalActiveDays'] as num?)?.toInt() ?? 0,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.tryParse(json['lastActiveAt'].toString()),
      secondsPerDay: (json['secondsPerDay'] as num?)?.toInt() ?? 0,
      daysPerWeek: (json['daysPerWeek'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
    );
  }
}
