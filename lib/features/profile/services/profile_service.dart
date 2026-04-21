import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/profile_model.dart';

class ProfileService {
  final Dio _dio = ApiClient().dio;

  /// GET /api/account/me
  Future<ProfileModel> getMyProfile() async {
    final response = await _dio.get('/api/account/me');
    print('Profile data: ${response.data}');
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// PUT /api/account/me
  Future<ProfileModel> updateMyProfile({
    String? facebookName,
    String? facebookLink,
  }) async {
    final response = await _dio.put(
      '/api/account/me',
      data: {'facebookName': facebookName, 'facebookLink': facebookLink},
    );
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }
}
