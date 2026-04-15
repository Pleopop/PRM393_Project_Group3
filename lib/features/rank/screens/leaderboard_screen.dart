import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Chỉ giữ lại Riverpod, xóa bỏ provider cũ

import '../../../core/theme/app_theme.dart';
import '../providers/leaderboard_provider.dart';
import '../models/leaderboard_model.dart';

import '../widgets/stat_card.dart';
import '../widgets/leaderboard_header.dart';
import '../widgets/leaderboard_row_item.dart';
import '../widgets/top5section.dart'; // Đảm bảo tên file này khớp với máy bạn nhé

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. SỬA Ở ĐÂY: Dùng ref.read thay vì context.read
      ref.read(leaderboardProvider).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. SỬA Ở ĐÂY: Dùng ref.watch để lấy dữ liệu (không cần nhét vào Builder nữa)
    final provider = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bảng Xếp Hạng', style: TextStyle(color: AppColors.foreground)), 
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      
      // Tách phần giao diện chính ra một hàm cho mượt
      body: _buildBody(provider), 
    );
  }

  // Hàm phụ xử lý các trạng thái giao diện
  Widget _buildBody(LeaderboardProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.error != null) return Center(child: Text(provider.error!, style: const TextStyle(color: Colors.red)));
    if (provider.data == null) return const Center(child: Text('Không có dữ liệu'));

    final vm = provider.data!;
    final myRow = vm.rows.cast<LeaderboardMember?>().firstWhere((m) => m?.isMe == true, orElse: () => null);
    final top5 = vm.rows.take(5).toList();

    return RefreshIndicator(
      onRefresh: () => provider.loadData(),
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
                  StatCard(label: "Tổng giờ học", rawValue: vm.totalHours, suffix: 'h', icon: Icons.show_chart, trendValue: 4.2, gradientColors: const [Color(0xFFA78BFA), Color(0xFF7C3AED)]),
                  StatCard(label: "TB mỗi người", rawValue: vm.avgHours, suffix: 'h', icon: Icons.bolt, trendValue: 1.8, gradientColors: const [Color(0xFFF472B6), Color(0xFF7C3AED)]),
                  StatCard(label: "Xếp hạng của tôi", rawValue: myRow?.rank.toDouble() ?? 0, suffix: '', icon: Icons.bookmark, trendValue: 0.0, gradientColors: const [Color(0xFFC4B5FD), Color(0xFF8B5CF6)]),
                  StatCard(label: "Thành viên", rawValue: vm.memberCount.toDouble(), suffix: 'người', icon: Icons.people, trendValue: -2.1, gradientColors: const [Color(0xFFA78BFA), Color(0xFFF472B6)]),
                ],
              );
            }
          ),
          const SizedBox(height: 16),
          
          if (top5.isNotEmpty) ...[
            Top5Section(top5Users: top5),
            const SizedBox(height: 16),
          ],
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppColors.radius)),
            child: Column(
              children: [
                const LeaderboardHeader(),
                ...vm.rows.map((user) => LeaderboardRowItem(user: user)).toList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}