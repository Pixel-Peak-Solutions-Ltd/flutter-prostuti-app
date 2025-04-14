// profile_update_viewmodel.dart
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/profile/repository/profile_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_update_viewmodel.g.dart';

@riverpod
class ProfileUpdateState extends _$ProfileUpdateState {
  @override
  AsyncValue<Either<ErrorResponse, bool>> build() {
    return const AsyncValue.data(Right(false));
  }

  Future<void> updateProfile({
    String? name,
    XFile? image,
    required String studentId,
  }) async {
    // Don't update if no change
    if (name == null && image == null) {
      return;
    }

    state = const AsyncValue.loading();

    try {
      final result = await ref.read(profileRepoProvider).updateProfile(
            name: name,
            image: image,
            studentId: studentId,
          );

      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void resetState() {
    state = const AsyncValue.data(Right(false));
  }
}

// Providers for name and profile image fields
@riverpod
class ProfileName extends _$ProfileName {
  @override
  String build() => '';

  void setName(String name) {
    state = name;
  }
}

@riverpod
class ProfileImage extends _$ProfileImage {
  @override
  XFile? build() => null;

  void setImage(XFile? image) {
    state = image;
  }
}
