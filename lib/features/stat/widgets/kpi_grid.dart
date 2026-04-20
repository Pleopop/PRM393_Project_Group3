import 'package:flutter/material.dart';
import '../../rank/widgets/stat_card.dart'; 
class KpiGrid extends StatelessWidget {
  final dynamic data;
  const KpiGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: [
        _miniCard(Icons.trending_up, "${data.avgHours}h", "TB/ngày", const Color(0xFFA594F9)),
        _miniCard(Icons.local_fire_department, "${data.currentStreak.toInt()}", "Streak", const Color(0xFFCB80AB)),
        _miniCard(Icons.track_changes, "${data.weeklyProgress.toInt()}%", "KPI", const Color(0xFF8967B3)),
        _miniCard(Icons.access_time, "${data.totalHours.toInt()}h", "Tổng giờ", const Color(0xFFA594F9)),
        _miniCard(Icons.calendar_month, "${data.totalActiveDays.toInt()}", "Ngày học", const Color(0xFF8967B3)),
      ],
    );
  }

  Widget _miniCard(IconData icon, String value, String label, Color color) {
    return Container(
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}