import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stat_model.dart';
import '../services/stat_service.dart';

final statServiceProvider = Provider((ref) => StatService());

final userStatProvider = StateNotifierProvider<StatNotifier, AsyncValue<UserStatModel>>((ref) {
  return StatNotifier(ref.watch(statServiceProvider));
});

class StatNotifier extends StateNotifier<AsyncValue<UserStatModel>> {
  final StatService _service;
  
  StatNotifier(this._service) : super(const AsyncValue.loading()) {
    fetchStats(); 
  }

  Future<void> fetchStats() async {
    state = const AsyncValue.loading();
    try {
      final data = await _service.getMyStats();
      state = AsyncValue.data(data); 
    } catch (e, stack) {
      state = AsyncValue.error(e, stack); 
    }
  }
}