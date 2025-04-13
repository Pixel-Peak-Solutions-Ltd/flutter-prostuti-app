// __brick__/repository/profile_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repo.g.dart';

@riverpod
ProfileRepo profileRepo(ProfileRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return ProfileRepo(dioService);
}

class ProfileRepo {
  final DioService _dioService;

  ProfileRepo(this._dioService);

  Future<Either<ErrorResponse, bool>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final payload = {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final response =
          await _dioService.postRequest("/auth/change-password", payload);

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        ErrorHandler().setErrorMessage(errorResponse.message);
        return Left(errorResponse);
      }
    } catch (e) {
      final errorResponse = ErrorResponse(
        message: e.toString(),
        success: e.toString() == 'true',
      );
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
