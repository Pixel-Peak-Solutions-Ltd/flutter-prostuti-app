import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/profile/repository/profile_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_viewmodel.g.dart';

@riverpod
class ChangePasswordState extends _$ChangePasswordState {
  @override
  AsyncValue<Either<ErrorResponse, bool>> build() {
    return const AsyncValue.data(Right(false));
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await ref.read(profileRepoProvider).changePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
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

// Providers for individual password fields
@riverpod
class OldPassword extends _$OldPassword {
  @override
  String build() => '';

  void setPassword(String password) {
    state = password;
  }
}

@riverpod
class NewPassword extends _$NewPassword {
  @override
  String build() => '';

  void setPassword(String password) {
    state = password;
  }
}

@riverpod
class ConfirmPassword extends _$ConfirmPassword {
  @override
  String build() => '';

  void setPassword(String password) {
    state = password;
  }
}
