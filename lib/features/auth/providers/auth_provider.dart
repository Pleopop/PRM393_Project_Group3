import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../routes/app_router.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// ─── Service provider ────────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// ─── Auth state notifier ─────────────────────────────────────────────────────

/// Holds the current [UserModel] or null when logged out.
/// Uses [AsyncValue] so the UI can show loading/error states easily.
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      return AuthNotifier(ref.watch(authServiceProvider));
    });

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    _init();
  }

  /// Restore session from secure storage on app start.
  Future<void> _init() async {
    state = await AsyncValue.guard(() => _authService.getUser());
  }

  /// Open Discord OAuth2 page in the browser.
  /// The actual token exchange happens in [handleCallback].
  Future<void> loginToDiscord() async {
    await _authService.loginToDiscord();
  }

  /// Called after Discord redirects back with [code].
  /// Exchanges the code for a JWT and updates state.
  Future<void> handleCallback(String code) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.exchangeCode(code));
  }

  /// Logs out: calls the backend, clears local state, then redirects to login.
  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncValue.data(null);
    AppRouter.router.go(AppConstants.routeLogin);
  }
}
