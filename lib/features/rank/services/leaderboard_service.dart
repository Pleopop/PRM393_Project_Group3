import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leaderboard_model.dart';
// import '../../../core/api/api_client.dart'; 

class LeaderboardService {
  final String _apiUrl = 'https://localhost:5001/api/leaderboard';

  Future<LeaderboardVM> fetchLeaderboardData() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return LeaderboardVM.fromJson(jsonData);
      } else {
        throw Exception('Lỗi Server: ${response.statusCode}');
      }
    } catch (e) {
      // MOCK DATA ĐỂ TEST GIAO DIỆN (Xóa đoạn này khi nối API thật)
      await Future.delayed(const Duration(seconds: 1)); // Giả lập mạng chậm 1s
      return LeaderboardVM(
        totalHours: 1250.5, avgHours: 4.2, memberCount: 156,
        rows: [
          LeaderboardMember(id: '1', name: 'Nguyễn Văn A', hours: 45.5, rank: 1, changeRank: 2, trend: 'up'),
          LeaderboardMember(id: '2', name: 'Trần Thị B', hours: 42.0, rank: 2, changeRank: 0, trend: 'flat', isMe: true),
          LeaderboardMember(id: '3', name: 'Lê Hoàng C', hours: 38.5, rank: 3, changeRank: -1, trend: 'down'),
        ]
      );
      // HẾT ĐOẠN MOCK DATA
    }
  }
}