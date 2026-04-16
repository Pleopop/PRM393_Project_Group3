import 'package:flutter/material.dart';
import '../models/leaderboard_model.dart';
import '../services/leaderboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class LeaderboardProvider extends ChangeNotifier {
  final LeaderboardService _service = LeaderboardService();

  LeaderboardVM? data;
  bool isLoading = false;
  String? error;

  // Hàm gọi API và cập nhật UI
  Future<void> loadData() async {
    isLoading = true;
    error = null;
    notifyListeners(); // Báo UI hiện icon loading

    try {
      data = await _service.fetchLeaderboardData();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // Báo UI tắt loading, hiện data hoặc báo lỗi
    }
  }
}
final leaderboardProvider = ChangeNotifierProvider<LeaderboardProvider>((ref) {
  return LeaderboardProvider();
});