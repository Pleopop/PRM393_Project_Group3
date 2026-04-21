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
              color: user.rank > 0 ? rankColor.withOpacity(0.15) : Colors.transparent, 
            ),
            child: Text(
              user.rank > 0 ? '${user.rank}' : '-', 
              style: TextStyle(
                color: user.rank > 0 ? rankColor : AppColors.mutedForeground.withOpacity(0.5), 
                fontWeight: FontWeight.bold, 
                fontSize: user.rank > 0 ? 13 : 18, 
              )
            ),
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
                    // Hiển thị ảnh Discord nếu có URL
                    image: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(user.avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  // Nếu KHÔNG có ảnh thì mới hiện chữ cái đầu
                  child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                      ? Text(getInitials(user.name), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: user.isMe ? p1 : Colors.white70))
                      : null,
                ),
                
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