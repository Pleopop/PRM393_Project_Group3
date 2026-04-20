import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/stat_model.dart';

class StatService {
  Future<UserStatModel> getMyStats() async {
    try {
      // Call API tool 
      final response = await ApiClient().dio.get('/api/account/me/stats');
      
      return UserStatModel.fromJson(response.data);
      
    } on DioException catch (e) {
      throw Exception('Lỗi API Thống kê: ${e.response?.statusCode} - ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}