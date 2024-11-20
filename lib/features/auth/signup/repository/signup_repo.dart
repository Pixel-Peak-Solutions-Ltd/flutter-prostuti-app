import 'package:prostuti/core/services/dio_service.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/core/services/api_response.dart';

import '../model/otp_model.dart';

part 'signup_repo.g.dart';

@riverpod
SignupRepo signupRepo(SignupRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return SignupRepo(dioService);
}

class SignupRepo {
  final DioService _dioService;

  SignupRepo(this._dioService);

  Future<ApiResponse> sendVerificationCode(
      {required String phoneNo, String type = "ACCOUNT_CREATION"}) async {
    final payload = {
      "phoneNumber": "+88$phoneNo",
      "phoneVerificationType": type
    };

    final response = await _dioService.postRequest(
        "/phone-verification/send-verification-code", payload);

    if (response.statusCode == 200) {
      return ApiResponse.success(response.data['success']);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    }
  }

  Future<ApiResponse> verifyPhoneNumber(
      {required phoneNo, required code, required String type}) async {
    final payload = {
      "phoneNumber": phoneNo.toString(),
      "otpCode": code.toString(),
      "phoneVerificationType": type
    };

    final response = await _dioService.postRequest(
        "/phone-verification/verify-phone-number", payload);

    if (response.statusCode == 200) {
      return ApiResponse.success(OTP.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    }
  }

  Future<ApiResponse> registerStudent(Map<String, String> payload) async {
    final response =
        await _dioService.postRequest("/auth/register-student", payload);

    if (response.statusCode == 200) {
      return ApiResponse.success(response.data["success"]);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    }
  }
}
