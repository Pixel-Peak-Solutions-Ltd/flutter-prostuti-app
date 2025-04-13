// lib/features/payment/repository/payment_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/models/student_profile.dart';
import '../../../core/services/error_handler.dart';
import '../model/voucher_model.dart';

part 'payment_repo.g.dart';

@riverpod
PaymentRepo paymentRepo(PaymentRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return PaymentRepo(dioService);
}

class PaymentRepo {
  final DioService _dioService;

  PaymentRepo(this._dioService);

// lib/features/payment/repository/payment_repo.dart - Updated initiatePayment method

  Future<Either<ErrorResponse, String?>> initiatePayment(
      Map<String, dynamic> payload) async {
    try {
      // Extract key values
      final courseIds = payload["course_id"];
      final priceValue = (payload["totalPrice"] ?? 0).toInt();

      // Create a simplified payload with only what's needed
      final apiPayload = {
        "course_id": courseIds,
      };

      // Only add voucher fields if needed
      if (payload["isVoucherAdded"] == true && payload["voucher_id"] != null) {
        apiPayload["isVoucherAdded"] = true;
        apiPayload["voucher_id"] = payload["voucher_id"];
      }

      // Debug what we're sending
      print("Sending payload to enroll-course/paid/init: $apiPayload");

      final response =
          await _dioService.postRequest("/enroll-course/paid/init", apiPayload);

      // Debug the response
      print("Response from enroll-course/paid/init: ${response.data}");

      if (response.statusCode == 200) {
        final paymentUrl = response.data['data'];
        if (paymentUrl != null &&
            paymentUrl is String &&
            paymentUrl.isNotEmpty) {
          return Right(paymentUrl);
        } else if (response.data['success'] == true) {
          return const Right(null);
        } else {
          return Left(ErrorResponse(
            success: false,
            message: "Invalid payment URL received",
          ));
        }
      } else if (response.statusCode == 409) {
        return const Right(null);
      } else {
        return Left(ErrorResponse.fromJson(response.data));
      }
    } catch (e) {
      print("Payment error: $e");
      return Left(ErrorResponse(
        success: false,
        message: "Payment initialization failed: ${e.toString()}",
      ));
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

  // Subscription payment
  Future<Either<ErrorResponse, String?>> subscribe(
      Map<String, dynamic> payload) async {
    try {
      // For subscription, the API expects 'requestedPlan'
      final apiPayload = {"requestedPlan": payload["requestedPlan"]};

      // Add voucher if applicable
      if (payload["isVoucherAdded"] == true && payload["voucher_id"] != null) {
        apiPayload["isVoucherAdded"] = true;
        apiPayload["voucher_id"] = payload["voucher_id"];
      }

      final response = await _dioService.postRequest(
          "/payment/subscription/init", apiPayload);

      if (response.statusCode == 200) {
        // Check if the data is a valid string URL
        final paymentUrl = response.data['data'];
        if (paymentUrl != null &&
            paymentUrl is String &&
            paymentUrl.isNotEmpty) {
          return Right(paymentUrl);
        } else if (response.data['success'] == true) {
          // Already subscribed case
          return const Right(null);
        } else {
          return Left(ErrorResponse(
            success: false,
            message: "Invalid subscription URL received",
          ));
        }
      } else if (response.statusCode == 409) {
        // Already subscribed
        return const Right(null);
      } else {
        return Left(ErrorResponse.fromJson(response.data));
      }
    } catch (e) {
      print("Subscription error: $e");
      return Left(ErrorResponse(
        success: false,
        message: "Subscription initialization failed: ${e.toString()}",
      ));
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

  // Voucher-related methods
  Future<Either<ErrorResponse, List<VoucherModel>>> getAllVouchers(
      {String? courseId}) async {
    try {
      // Build query parameters
      Map<String, dynamic> params = {'isActive': 'true', 'isExpired': 'false'};

      if (courseId != null) {
        params['course_id'] = courseId;
      }

      // Add student parameter to include student-specific vouchers
      params['student'] = 'true';

      final response = await _dioService.getRequest(
        "/voucher/all-voucher",
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        // Check the structure of the response and handle accordingly
        if (response.data['data'] is List) {
          // Direct list format
          final dataList = response.data['data'] as List;
          final vouchers =
              dataList.map((json) => VoucherModel.fromJson(json)).toList();
          return Right(vouchers);
        } else if (response.data['data'] is Map &&
            response.data['data']['data'] is List) {
          // Nested data format (with meta)
          final dataList = response.data['data']['data'] as List;
          final vouchers =
              dataList.map((json) => VoucherModel.fromJson(json)).toList();
          return Right(vouchers);
        } else {
          // If we can't parse the data as a list, return an empty list
          print(
              "Warning: Unexpected response format for vouchers: ${response.data}");
          return const Right([]);
        }
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        ErrorHandler().setErrorMessage(errorResponse.message);
        return Left(errorResponse);
      }
    } catch (e) {
      print("Error fetching vouchers: $e");
      return Left(ErrorResponse(
        success: false,
        message: e.toString(),
      ));
    }
  }

  Future<Either<ErrorResponse, VoucherResponse>> validateVoucher(
      String voucherId,
      {String? courseId}) async {
    try {
      final Map<String, dynamic> payload = {'voucher_id': voucherId};
      if (courseId != null) {
        payload['course_id'] = courseId;
      }

      final response =
          await _dioService.postRequest("/voucher/validate", payload);

      if (response.statusCode == 200) {
        return Right(VoucherResponse.fromJson(response.data));
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        ErrorHandler().setErrorMessage(errorResponse.message);
        return Left(errorResponse);
      }
    } catch (e) {
      return Left(ErrorResponse(
        success: false,
        message: e.toString(),
      ));
    }
  }
}
