import 'package:flutter/material.dart';

class WeeklyProgressCard extends StatelessWidget {
  final double progress;
  final double target;

  const WeeklyProgressCard({Key? key, required this.progress, required this.target}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color violet = const Color(0xFFA594F9);
    final Color sage = const Color(0xFFCB80AB);
    
    final double pct = target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: violet.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: violet.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: violet),
              const SizedBox(width: 8),
              const Text("Mục tiêu tuần", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Đạt ${progress.toInt()}h / ${target.toInt()}h", style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text("${(pct * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: pct),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
            builder: (context, value, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: violet.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(sage),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            target - progress > 0 
                ? "Cố lên! Bạn chỉ cần ${(target - progress).toInt()}h nữa để hoàn thành mục tiêu."
                : "Tuyệt vời! Bạn đã hoàn thành mục tiêu tuần này.",
            style: TextStyle(fontSize: 12, color: sage),
          ),
        ],
      ),
    );
  }
}