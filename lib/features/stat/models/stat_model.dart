class UserStatModel {
  final int userId;
  final String displayName;
  final String? avatarUrl;
  final double currentStreak;
  final double totalHours;
  final double avgHours;
  // final double globalRank;
  final double totalActiveDays;
  final double weeklyProgress; 
  final double weeklyTarget; 

  UserStatModel({
    required this.userId, required this.displayName, this.avatarUrl,
    required this.currentStreak, required this.totalHours, required this.avgHours,
    required this.totalActiveDays,
    required this.weeklyProgress, required this.weeklyTarget,
  });

  factory UserStatModel.fromJson(Map<String, dynamic> json) {
    return UserStatModel(
      userId: json['userId'] ?? '',
      displayName: json['fullName'] ?? '',
      avatarUrl: json['avatarUrl'],
      currentStreak: (json['currentStreak'] ?? 0).toDouble(),
      totalHours: (json['totalHours'] ?? 0).toDouble(),
      avgHours: (json['avgHours'] ?? 0).toDouble(),
      // globalRank: (json['globalRank'] ?? 0).toDouble(),
      totalActiveDays: (json['totalActiveDays'] ?? 0).toDouble(),
      weeklyProgress: (json['weeklyProgress'] ?? 0).toDouble(),
      weeklyTarget: (json['weeklyTarget'] ?? 40).toDouble(),
    );
  }
}