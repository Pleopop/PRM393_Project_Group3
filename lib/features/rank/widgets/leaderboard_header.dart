import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            SizedBox(width: 36, child: Text("HẠNG", style: TextStyle(fontSize: 10, color: AppColors.mutedForeground, fontWeight: FontWeight.bold))),
            Expanded(child: Text("THÀNH VIÊN", style: TextStyle(fontSize: 10, color: AppColors.mutedForeground, fontWeight: FontWeight.bold))),
            Text("GIỜ", style: TextStyle(fontSize: 10, color: AppColors.mutedForeground, fontWeight: FontWeight.bold)),
          ],
        ),
        Divider(color: AppColors.border, height: 16),
      ],
    );
  }
}