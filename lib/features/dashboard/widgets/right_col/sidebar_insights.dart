part of '../right_col.dart';

class SidebarInsights extends StatelessWidget {
  final List<double> timeOfDayHours;
  final StreakCalendarModel streakCalendar;

  const SidebarInsights({
    super.key,
    required this.timeOfDayHours,
    required this.streakCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SurfaceCard(child: _TimeOfDayCard(hours: timeOfDayHours)),
        const SizedBox(height: 12),
        Expanded(
          child: _SurfaceCard(child: _StreakCalendarCard(calendar: streakCalendar)),
        ),
      ],
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;
  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: _p1.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
