import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_group3/app.dart';
import '../core/constants/app_constants.dart';
import '../features/dashboard/widgets/dashboard_colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    AppConstants.routeDashboard,
    AppConstants.routeRank,
    AppConstants.routePolicies,
    AppConstants.routeStats,
    AppConstants.routeProfile,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: DashboardColors.border, width: 0.5),
          ),
        ),

        child: BottomNavigationBar(
          backgroundColor: DashboardColors.bg,
          selectedItemColor: DashboardColors.primary,
          unselectedItemColor: DashboardColors.textSub,

          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_outlined),
              activeIcon: Icon(Icons.leaderboard),
              label: 'Rank',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.policy_outlined),
              activeIcon: Icon(Icons.policy),
              label: 'Policies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
