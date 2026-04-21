import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>(
  (_) => ProfileService(),
);

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
      return ProfileNotifier(ref.watch(profileServiceProvider));
    });

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final ProfileService _service;

  ProfileNotifier(this._service) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.getMyProfile());
  }

  /// Returns the updated [ProfileModel] on success, throws on error.
  Future<ProfileModel> update({
    String? facebookName,
    String? facebookLink,
  }) async {
    final updated = await _service.updateMyProfile(
      facebookName: facebookName,
      facebookLink: facebookLink,
    );
    state = AsyncValue.data(updated);
    return updated;
  }
}
