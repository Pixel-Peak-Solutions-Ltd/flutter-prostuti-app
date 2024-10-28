import 'package:flutter/foundation.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/features/signup/model/otp_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/error_handler.dart';

part 'signup_repo.g.dart';

@riverpod
SignupRepo signupRepo(SignupRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return SignupRepo(dioService);
}

class SignupRepo {
  final DioService _dioService;

  SignupRepo(this._dioService);

  Future<bool> sendVerificationCode({required String phoneNo}) async {
    final payload = {
      "phoneNumber": "+88$phoneNo",
      "phoneVerificationType": "ACCOUNT_CREATION"
    };

    final response = await _dioService.postRequest(
        "/phone-verification/send-verification-code", payload);

    if (response.statusCode == 200) {
      return response.data["success"];
    } else {
      ErrorHandler().setErrorMessage(response.statusMessage);
      if (kDebugMode) {
        print(response.data);
      }
    }

    return false;
  }

  Future<OTP> verifyPhoneNumber(
      {required phoneNo, required code, required String type}) async {
    final payload = {
      "phoneNumber": phoneNo.toString(),
      "otpCode": code.toString(),
      "phoneVerificationType": type
    };

    final response = await _dioService.postRequest(
        "/phone-verification/verify-phone-number", payload);

    if (response.statusCode == 200) {
      return OTP.fromJson(response.data);
    } else {
      ErrorHandler().setErrorMessage(response.statusMessage);
      if (kDebugMode) {
        print(response.statusMessage);
      }
    }

    return OTP.fromJson(response.data);
  }

  Future<bool> registerStudent(Map<String, String> payload) async {
    final response =
        await _dioService.postRequest("/auth/register-student", payload);

    if (response.statusCode == 200) {
      return response.data["success"];
    } else {
      ErrorHandler().setErrorMessage(response.statusMessage);
      if (kDebugMode) {
        print(response.statusMessage);
      }
    }

    return false;
  }
}
