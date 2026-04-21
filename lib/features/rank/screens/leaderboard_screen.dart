import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/leaderboard_provider.dart';
import '../models/leaderboard_model.dart';

// Nhớ import các widget con của bác
import '../widgets/stat_card.dart';
import '../widgets/leaderboard_header.dart';
import '../widgets/leaderboard_row_item.dart';
import '../widgets/top5section.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Bảng Xếp Hạng',
          style: TextStyle(color: AppColors.foreground),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),

      body: rankAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFA78BFA)),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                err.toString(),
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(leaderboardProvider.notifier).loadData(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        data: (vm) {
          final myRow = vm.rows.cast<LeaderboardMember?>().firstWhere(
            (m) => m?.isMe == true,
            orElse: () => null,
          );
          final activeLearners = vm.rows
              .where((user) => user.hours > 0)
              .toList();
          final top5 = activeLearners.take(5).toList();
          return RefreshIndicator(
            onRefresh: () => ref.read(leaderboardProvider.notifier).loadData(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    double cardRatio = constraints.maxWidth < 400 ? 1.4 : 1.7;
                    int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: cardRatio,
                      children: [
                        StatCard(
                          label: "Tổng giờ học",
                          rawValue: vm.totalHours,
                          suffix: 'h',
                          icon: Icons.show_chart,
                          trendValue: 4.2,
                          gradientColors: const [
                            Color(0xFFA78BFA),
                            Color(0xFF7C3AED),
                          ],
                        ),
                        StatCard(
                          label: "TB mỗi người",
                          rawValue: vm.avgHours,
                          suffix: 'h',
                          icon: Icons.bolt,
                          trendValue: 1.8,
                          gradientColors: const [
                            Color(0xFFF472B6),
                            Color(0xFF7C3AED),
                          ],
                        ),
                        StatCard(
                          label: "Xếp hạng của tôi",
                          rawValue: myRow?.rank.toDouble() ?? 0,
                          suffix: '',
                          icon: Icons.bookmark,
                          trendValue: 0.0,
                          gradientColors: const [
                            Color(0xFFC4B5FD),
                            Color(0xFF8B5CF6),
                          ],
                        ),
                        StatCard(
                          label: "Thành viên",
                          rawValue: vm.memberCount.toDouble(),
                          suffix: 'người',
                          icon: Icons.people,
                          trendValue: -2.1,
                          gradientColors: const [
                            Color(0xFFA78BFA),
                            Color(0xFFF472B6),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Khối Top 5
                if (top5.isNotEmpty) ...[
                  Top5Section(top5Users: top5),
                  const SizedBox(height: 16),
                ]else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.card, 
                      borderRadius: BorderRadius.circular(AppColors.radius)
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.emoji_events_outlined, size: 40, color: AppColors.mutedForeground.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        const Text(
                          "Bảng xếp hạng Top 5 đang trống!", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tuần này chưa có ai ghi danh. Hãy học ngay để chiếm Top 1!", 
                          style: TextStyle(color: AppColors.mutedForeground, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppColors.radius),
                  ),
                  child: Column(
                    children: [
                      const LeaderboardHeader(),
                      ...vm.rows
                          .map((user) => LeaderboardRowItem(user: user))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
