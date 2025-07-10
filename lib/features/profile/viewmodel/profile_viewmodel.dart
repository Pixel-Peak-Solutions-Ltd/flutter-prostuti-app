// profile_viewmodel.dart

import 'package:prostuti/common/helpers/local_storage_service.dart';
import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/models/student_profile.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<StudentProfile> build() async {
    final localStorage = ref.watch(localStorageServiceProvider);

    // Try to load profile from the cache when the provider is first read.
    final cachedProfile = await localStorage.getUserProfile();
    if (cachedProfile != null) {
      // If a cached profile exists, display it immediately.
      // The UI will show this data while new data is fetched in the background.
      state = AsyncData(cachedProfile);
    }

    // Always fetch fresh data from the network to ensure it's up-to-date.
    // This will automatically update the state from loading to data or error.
    return await _fetchAndCacheProfile();
  }

  Future<StudentProfile> _fetchAndCacheProfile() async {
    final response = await ref.read(paymentRepoProvider).getStudentProfile();
    final localStorage = ref.read(localStorageServiceProvider);

    return response.fold(
      (l) => throw Exception(l.message), // Handle error case
      (profile) {
        // After a successful network fetch, save the new profile to the cache.
        localStorage.saveUserProfile(profile);
        return profile;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    // The guard will automatically call _fetchAndCacheProfile to get new data and update the cache.
    state = await AsyncValue.guard(() => _fetchAndCacheProfile());
  }
}
