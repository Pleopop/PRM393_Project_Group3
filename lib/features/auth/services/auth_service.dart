import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final _api = ApiClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<UserModel> login(String email, String password) async {
    final response = await _api.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;

    // Save tokens securely
    await _storage.write(
      key: AppConstants.accessTokenKey,
      value: data['access_token'] as String,
    );
    if (data['refresh_token'] != null) {
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: data['refresh_token'] as String,
      );
    }

    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null && token.isNotEmpty;
  }
}
