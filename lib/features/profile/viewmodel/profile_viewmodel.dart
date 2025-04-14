import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/models/student_profile.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<StudentProfile> build() async {
    return await _userProfile();
  }

  Future<StudentProfile> _userProfile() async {
    final response = await ref.read(paymentRepoProvider).getStudentProfile();

    return response.fold(
      (l) => throw Exception(l.message), // Handle error case
      (profile) {
        return profile;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _userProfile());
  }
}
