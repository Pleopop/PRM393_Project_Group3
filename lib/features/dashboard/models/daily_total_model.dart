class DailyTotalModel {
  final int userId;
  final DateTime date;
  final String dayLabel;
  final int seconds;

  const DailyTotalModel({
    required this.userId,
    required this.date,
    required this.dayLabel,
    required this.seconds,
  });

  factory DailyTotalModel.fromJson(Map<String, dynamic> json) {
    return DailyTotalModel(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      date: DateTime.tryParse((json['date'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      dayLabel: (json['dayLabel'] ?? '').toString(),
      seconds: (json['seconds'] as num?)?.toInt() ?? 0,
    );
  }
}
