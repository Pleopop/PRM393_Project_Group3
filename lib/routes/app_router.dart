import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/services/auth_service.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/rank/screens/leaderboard_screen.dart';
import '../features/policies/screens/policies_screen.dart';
import '../features/stat/screens/stat_screen.dart';
import 'main_shell.dart';

class AppRouter {
  AppRouter._();

  static final _authService = AuthService();

  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.routeLogin,
    redirect: (context, state) async {
      // final isLoggedIn = await _authService.isLoggedIn();
      // final isLoginPage = state.matchedLocation == AppConstants.routeLogin;

      // if (!isLoggedIn && !isLoginPage) return AppConstants.routeLogin;
      // if (isLoggedIn && isLoginPage) return AppConstants.routeDashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppConstants.routeDashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppConstants.routeRank,
              builder: (context, state) => const LeaderboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppConstants.routePolicies,
              builder: (context, state) => const PoliciesScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppConstants.routeStats,
              builder: (context, state) => const StatScreen(), // Gọi màn hình Stat của bạn
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppConstants.routeProfile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
