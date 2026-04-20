class LeaderboardMember {
  final String id;
  final String name;
  final double hours;
  final int rank;
  final int changeRank;
  final String trend;
  final bool isMe;
  final String? avatarUrl;

  LeaderboardMember({
    required this.id, required this.name, required this.hours, required this.rank,
    required this.changeRank, required this.trend, this.isMe = false, this.avatarUrl,
  });

  factory LeaderboardMember.fromJson(Map<String, dynamic> json) {
    int seconds = json['totalSeconds'] ?? 0;
    
    return LeaderboardMember(
      id: json['userId']?.toString() ?? '',
      name: json['username'] ?? 'Unknown',
      hours: seconds / 3600.0,
      rank: json['rank'] ?? 0,
      changeRank: json['changeRank'] ?? 0,
      trend: (json['changeRank'] ?? 0) >= 0 ? 'up' : 'down',
      isMe: false, 
      avatarUrl: json['avatarUrl'],
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
    required this.avgHours, required this.memberCount
  });

  factory LeaderboardVM.fromJson(Map<String, dynamic> json) {
    var rowsList = json['rows'] as List? ?? [];
    List<LeaderboardMember> parsedRows = rowsList.map((i) => LeaderboardMember.fromJson(i)).toList();

    double total = parsedRows.fold(0, (sum, item) => sum + item.hours);
    double avg = parsedRows.isNotEmpty ? (total / parsedRows.length) : 0;

    return LeaderboardVM(
      rows: parsedRows,
      totalHours: total,
      avgHours: avg,
      memberCount: parsedRows.length,
    );
  }
}