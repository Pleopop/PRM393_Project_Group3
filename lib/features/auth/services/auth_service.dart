import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final _api = ApiClient().dio;
  final _storage = const FlutterSecureStorage();

  // ─── Device ID ────────────────────────────────────────────────────────────

  /// Returns a persistent UUID for this device/install. Creates one on first call.
  Future<String> getDeviceId() async {
    var deviceId = await _storage.read(key: AppConstants.deviceIdKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      await _storage.write(key: AppConstants.deviceIdKey, value: deviceId);
    }
    return deviceId;
  }

  // ─── Discord OAuth ─────────────────────────────────────────────────────────

  /// Opens Discord's OAuth2 consent page in the external browser.
  /// Discord will redirect back to [AppConstants.discordRedirectUri] with ?code=...
  Future<void> loginToDiscord() async {
    final uri = Uri.https('discord.com', '/api/oauth2/authorize', {
      'client_id': AppConstants.discordClientId,
      'redirect_uri': AppConstants.discordRedirectUri,
      'response_type': 'code',
      'scope': AppConstants.discordScopes,
    });
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open Discord login page');
    }
  }

  // Future<void> loginToDiscord() async {
  //   final uri = Uri.https('discord.com', '/api/oauth2/authorize', {
  //     'client_id': AppConstants.discordClientId,
  //     'redirect_uri': AppConstants.discordRedirectUri,
  //     'response_type': 'code',
  //     'scope': AppConstants.discordScopes,
  //   });

  //   // Thử mở app Discord trước
  //   final discordAppUri = Uri.parse(
  //     'discord://discord.com/api/oauth2/authorize'
  //     '?client_id=${AppConstants.discordClientId}'
  //     '&redirect_uri=${AppConstants.discordRedirectUri}'
  //     '&response_type=code'
  //     '&scope=${AppConstants.discordScopes}',
  //   );

  //   if (await canLaunchUrl(discordAppUri)) {
  //     await launchUrl(discordAppUri, mode: LaunchMode.externalApplication);
  //   } else if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw Exception('Could not open Discord login page');
  //   }
  // }

  /// Exchanges the OAuth2 [code] for a JWT app token.
  /// POST /api/auth/discord/callback  →  { token, username, avatar }
  Future<UserModel> exchangeCode(String code) async {
    final deviceId = await getDeviceId();
    final response = await _api.post(
      '/api/auth/discord/callback',
      data: {'Code': code, 'DeviceId': deviceId, 'IsMobile': true},
    );
    final user = UserModel.fromJson(response.data as Map<String, dynamic>);
    await _saveUser(user);
    return user;
  }

  // ─── Logout ────────────────────────────────────────────────────────────────

  /// Calls the backend to invalidate this device's token, then clears local storage.
  Future<void> logout() async {
    final deviceId = await getDeviceId();
    try {
      await _api.post('/auth/logout', data: {'deviceId': deviceId});
    } catch (_) {
      // best-effort: clear local state even if the network call fails
    }
    await _clearUser();
  }

  // ─── Persistence ──────────────────────────────────────────────────────────

  Future<void> _saveUser(UserModel user) async {
    // Store JWT for the API interceptor
    await _storage.write(key: AppConstants.accessTokenKey, value: user.token);
    // Store full profile as JSON
    await _storage.write(
      key: AppConstants.authUserKey,
      value: jsonEncode(user.toJson()),
    );
    print('User saved to storage: ${user}');
  }

  /// Returns the cached [UserModel] or null if not logged in.
  Future<UserModel?> getUser() async {
    final raw = await _storage.read(key: AppConstants.authUserKey);
    if (raw == null || raw.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _clearUser() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.authUserKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null && token.isNotEmpty;
  }
}
