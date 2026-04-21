import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/leaderboard_model.dart';

class LeaderboardService {
  Future<LeaderboardVM> fetchLeaderboardData() async {
    try {
      final response = await ApiClient().dio.get('/api/dashboard/leaderboard');
      
      return LeaderboardVM.fromJson(response.data);
      
    } on DioException catch (e) {
      throw Exception('Lỗi API Xếp hạng: ${e.response?.statusCode} - ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}