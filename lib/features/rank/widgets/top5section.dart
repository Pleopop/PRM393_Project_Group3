import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../models/leaderboard_model.dart';

class Top5Section extends StatelessWidget {
  final List<LeaderboardMember> top5Users;

  const Top5Section({Key? key, required this.top5Users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomAppTheme>();
    final p1 = customTheme?.chart1 ?? const Color(0xFF7C3AED);
    final p2 = customTheme?.chart5 ?? const Color(0xFFF472B6);
    
    final List<Color> rankColors = [
      p1, p2, customTheme?.chart3 ?? Colors.orange, p1.withOpacity(0.6), p2.withOpacity(0.6)
    ];
    final List<String> rankMedals = ['🥇', '🥈', '🥉', '4️⃣', '5️⃣'];
    final List<String> rankLabels = ['1ST', '2ND', '3RD', '4TH', '5TH'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppColors.radius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Top 5
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [p1, p2]), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.emoji_events, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text("Top 5", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.foreground)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: p1.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
                child: Text("${getISOWeek(DateTime.now())}/${DateTime.now().year}", style: TextStyle(color: p1, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Divider(color: AppColors.border, height: 24),
          
          //Scroll horizontal list
          SizedBox(
            height: 110, 
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: top5Users.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                Color rc = rankColors[i];
                return Container(
                  width: 160,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: rc.withOpacity(0.08),
                    border: Border.all(color: rc.withOpacity(0.3), width: 1.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Positioned(left: -12, top: -12, bottom: -12, child: Container(width: 4, color: rc)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(rankLabels[i], style: TextStyle(color: rc, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              CircleAvatar(radius: 10, backgroundColor: rc.withOpacity(0.25), child: Text(getInitials(top5Users[i].name), style: TextStyle(color: rc, fontSize: 8, fontWeight: FontWeight.bold))),
                              const SizedBox(width: 6),
                              Expanded(child: Text(top5Users[i].name, overflow: TextOverflow.ellipsis, style: TextStyle(color: rc, fontWeight: FontWeight.bold, fontSize: 12))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text("${top5Users[i].hours.toStringAsFixed(1)}h", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.foreground, fontSize: 12)),
                        ],
                      ),
                      Positioned(right: 0, top: 0, child: Text(rankMedals[i], style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}