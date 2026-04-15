class LeaderboardMember {
  final String id;
  final String name;
  final double hours;
  final int rank;
  final int changeRank;
  final String trend; 
  final bool isMe;

  LeaderboardMember({
    required this.id, required this.name, required this.hours, 
    required this.rank, required this.changeRank, 
    required this.trend, this.isMe = false,
  });

  factory LeaderboardMember.fromJson(Map<String, dynamic> json) {
    return LeaderboardMember(
      id: json['id'].toString(),
      name: json['name'],
      hours: (json['hours'] as num).toDouble(),
      rank: json['rank'],
      changeRank: json['changeRank'],
      trend: json['trend'],
      isMe: json['isMe'] ?? false,
    );
  }
}

class LeaderboardVM {
  final List<LeaderboardMember> rows;
  final double totalHours;
  final double avgHours;
  final int memberCount;

  LeaderboardVM({
    required this.rows, required this.totalHours, 
    required this.avgHours, required this.memberCount,
  });

  factory LeaderboardVM.fromJson(Map<String, dynamic> json) {
    var list = json['rows'] as List;
    return LeaderboardVM(
      rows: list.map((i) => LeaderboardMember.fromJson(i)).toList(),
      totalHours: (json['totalHours'] as num).toDouble(),
      avgHours: (json['avgHours'] as num).toDouble(),
      memberCount: json['memberCount'],
    );
  }
}