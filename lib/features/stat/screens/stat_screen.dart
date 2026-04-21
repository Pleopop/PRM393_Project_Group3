import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/stat_provider.dart';

import '../widgets/stat_header_card.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/weekly_progress_card.dart';

class StatScreen extends ConsumerWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Lắng nghe Provider
    final statAsync = ref.watch(userStatProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Thống Kê Cá Nhân", style: TextStyle(color: AppColors.foreground)), 
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      
      body: statAsync.when(
        //wait for API
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFA594F9))),
        
        // Case 2 : Error API 
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(err.toString(), style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(userStatProvider.notifier).fetchStats(), // Nút thử lại
                child: const Text('Thử lại'),
              )
            ],
          )
        ),
        
        //Case 3 : Receive API success 
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.read(userStatProvider.notifier).fetchStats(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              StatHeaderCard(
                name: data.displayName,
                avatarUrl: data.avatarUrl,
                isEditing: false, 
                onEditToggle: () {}, 
              ),
              const SizedBox(height: 16),
              
              KpiGrid(data: data),
              const SizedBox(height: 16),
              
              WeeklyProgressCard(progress: data.weeklyProgress, target: data.weeklyTarget),
            ],
          ),
        ),
      ),
    );
  }
}