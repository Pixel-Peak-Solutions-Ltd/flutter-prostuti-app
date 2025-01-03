// __brick__/repository/test_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/features/course/materials/test/model/written_test_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

import '../../../../../core/services/error_handler.dart';
import '../../../../../core/services/error_response.dart';
import '../model/mcq_result_model.dart';
import '../model/mcq_test_details_model.dart';
import '../model/test_history_model.dart';
import '../model/test_model.dart';
import '../model/written_test_details_model.dart';

part 'test_repo.g.dart';

@riverpod
TestRepo testRepo(TestRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return TestRepo(dioService);
}


class TestRepo {
  final DioService _dioService;

  TestRepo(this._dioService);

  Future<Either<ErrorResponse, TestList>> getTestMCQList( String courseID) async {
    final response = await _dioService.getRequest("/test?type=MCQ&sortBy=lesson_id&sortOrder=asc&limit=40&course_id=$courseID");

    print(response.data);
    if (response.statusCode == 200) {
      return Right(TestList.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, WrittenTestList>> getTestWrittenList( String courseID) async {
    final response = await _dioService.getRequest("/test?type=Written&sortBy=lesson_id&sortOrder=asc&limit=40&course_id=$courseID");

    print(response.data);
    if (response.statusCode == 200) {
      return Right(WrittenTestList.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, MCQTestDetails>> getMCQTestById(
      String id) async {
    final response = await _dioService.getRequest("/test/$id");

    if (response.statusCode == 200) {
      return Right(MCQTestDetails.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, WrittenTestDetails>> getWrittenTestById(
      String id) async {
    final response = await _dioService.getRequest("/test/$id");

    if (response.statusCode == 200) {
      return Right(WrittenTestDetails.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, MCQResult>> submitMCQTest(
      {required Map<String, dynamic> payload}) async {
    final response = await _dioService.postRequest("/test-history/submit-test",payload);

    if (response.statusCode == 200) {
      return Right(MCQResult.fromJson(response.data));
    } else {
      print(response);
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<bool> hasMCQTestGiven(
      String id) async {
    final response = await _dioService.getRequest("/test-history/$id");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Either<ErrorResponse, TestHistory>> getMCQTestHistoryById(
      String id) async {
    final response = await _dioService.getRequest("/test-history/$id");

    if (response.statusCode == 200) {
      return Right(TestHistory.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}