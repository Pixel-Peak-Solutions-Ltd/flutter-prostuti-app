// __brick__/repository/forget_password_repo.dart
import 'package:flutter/foundation.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forget_password_repo.g.dart';

@riverpod
ForgetPasswordRepo forgetPasswordRepo(ForgetPasswordRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return ForgetPasswordRepo(dioService);
}

class ForgetPasswordRepo {
  final DioService _dioService;

  ForgetPasswordRepo(this._dioService);

  Future<bool> sendVerificationCodeForPasswordReset(
      {required String phoneNo}) async {
    final payload = {
      "phoneNumber": "+88$phoneNo",
      "phoneVerificationType": "PASSWORD_RESET"
    };

    final response = await _dioService.postRequest(
        "/phone-verification/send-verification-code", payload);

    if (response.statusCode == 200) {
      return response.data["success"];
    } else if (response.statusCode == 404) {
      return false;
    } else {
      if (kDebugMode) {
        print(response.data);
      }
    }

    return false;
  }

  Future<bool> resetPassword({required Map<String, String> payload}) async {
    final response =
        await _dioService.postRequest("/auth/student/reset-password", payload);

    if (response.statusCode == 200) {
      return response.data["success"];
    } else if (response.statusCode == 404) {
      return false;
    } else {
      if (kDebugMode) {
        print(response.data);
      }
    }
    return false;
  }
}
