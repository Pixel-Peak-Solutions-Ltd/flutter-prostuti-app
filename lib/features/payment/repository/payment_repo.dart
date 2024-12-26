// __brick__/repository/payment_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/models/student_profile.dart';
import '../../../core/services/error_handler.dart';

part 'payment_repo.g.dart';

@riverpod
PaymentRepo paymentRepo(PaymentRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return PaymentRepo(dioService);
}

class PaymentRepo {
  final DioService _dioService;

  PaymentRepo(this._dioService);

  Future initiatePayment(payload) async {
    final response =
        await _dioService.postRequest("/enroll-course/paid/init", payload);

    if (response.statusCode == 200) {
      return response.data['data'];
    } else if (response.statusCode == 409) {
      return response.data["success"];
    } else {
      response.data;
    }
  }

  Future<bool> enrollFreeCourse(payload) async {
    final response =
        await _dioService.postRequest("/enroll-course/free", payload);

    if (response.statusCode == 200) {
      return response.data['success'];
    } else {
      return response.data['success'];
    }
  }

  Future subscribe(payload) async {
    final response =
        await _dioService.postRequest("/payment/subscription/init", payload);

    if (response.statusCode == 200) {
      return response.data['data'];
    } else if (response.statusCode == 409) {
      return response.data["success"];
    } else {
      response.data;
    }
  }

  Future<Either<ErrorResponse, StudentProfile>> getStudentProfile() async {
    final response = await _dioService.getRequest("/user/profile");

    if (response.statusCode == 200) {
      return Right(StudentProfile.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<bool> enrollSubscribedCourse(payload) async {
    final response =
        await _dioService.postRequest("/enroll-course/subscription", payload);

    if (response.statusCode == 200) {
      return response.data['success'];
    } else if (response.statusCode == 409) {
      return response.data["success"];
    } else {
      return response.data["success"];
    }
  }
}
