import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/all_test_history_model.dart';

part 'test_history_repo.g.dart';

@riverpod
TestHistoryRepo testHistoryRepo(TestHistoryRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return TestHistoryRepo(dioService);
}

class TestHistoryRepo {
  final DioService _dioService;

  TestHistoryRepo(this._dioService);

  Future<Either<ErrorResponse, AllTestHistoryModel>> getAllTestHistory({
    required String studentId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dioService.getRequest(
        "/test-history/all-test-history?$studentId",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      if (response.statusCode == 200) {
        final testHistory = AllTestHistoryModel.fromJson(response.data);
        return Right(testHistory);
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        ErrorHandler().setErrorMessage(errorResponse.message);
        return Left(errorResponse);
      }
    } catch (e) {
      final errorResponse = ErrorResponse(
        message: e.toString(),
        success: false,
      );
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}