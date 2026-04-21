import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/leaderboard_model.dart';
import '../services/leaderboard_service.dart';

final leaderboardServiceProvider = Provider((ref) => LeaderboardService());

final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, AsyncValue<LeaderboardVM>>((ref) {
  return LeaderboardNotifier(ref.watch(leaderboardServiceProvider));
});

class LeaderboardNotifier extends StateNotifier<AsyncValue<LeaderboardVM>> {
  final LeaderboardService _service;

  LeaderboardNotifier(this._service) : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await _service.fetchLeaderboardData();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}