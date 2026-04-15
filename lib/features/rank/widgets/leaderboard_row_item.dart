import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../models/leaderboard_model.dart';

class LeaderboardRowItem extends StatelessWidget {
  final LeaderboardMember user;

  const LeaderboardRowItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomAppTheme>();
    final p1 = customTheme?.chart1 ?? const Color(0xFF7C3AED); // Tím
    
    // Màu cho Top 1, 2, 3
    Color getRankColor(int rank) {
      if (rank == 1) return p1;
      if (rank == 2) return const Color(0xFFF472B6); // Hồng
      if (rank == 3) return const Color(0xFFA78BFA); // Tím nhạt
      return AppColors.mutedForeground; // Hạng 4 trở đi màu xám
    }

    Color rankColor = getRankColor(user.rank);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Tăng padding giống Figma
      decoration: BoxDecoration(
        color: user.isMe ? p1.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(16), // Bo góc mềm mại hơn
      ),
      child: Row(
        children: [
          // 1. Cục Badge Thứ Hạng
          Container(
            width: 30, height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: rankColor.withOpacity(0.15), // Nền mờ của rank
            ),
            child: Text('${user.rank}', style: TextStyle(color: rankColor, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const SizedBox(width: 12),

          // 2. Avatar & Tên
          Expanded(
            child: Row(
              children: [
                // Cục Badge Avatar
                Container(
                  width: 30, height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: user.isMe ? p1.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  ),
                  child: Text(getInitials(user.name), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: user.isMe ? p1 : Colors.white70)),
                ),
                const SizedBox(width: 12),
                
                // Tên người dùng
                Expanded(
                  child: Text(
                    user.name, 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: user.isMe ? p1 : Colors.white, 
                      fontWeight: user.isMe ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14
                    )
                  ),
                ),
              ],
            ),
          ),
          
          // 3. Giờ học
          Text('${user.hours.toStringAsFixed(1)}h', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}