import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/mock_quiz_model.dart';

part 'mock_test_repo.g.dart';

@riverpod
MockTestRepo mockTestRepo(MockTestRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return MockTestRepo(dioService);
}

class MockTestRepo {
  final DioService _dioService;

  MockTestRepo(this._dioService);

  Future<Either<ErrorResponse, MockQuizResponse>> createMockQuiz({
    required Map<String, dynamic> payload,
  }) async {
    final response = await _dioService.postRequest("/quiz/create-mock-quiz", payload);

    if (response.statusCode == 200) {
      return Right(MockQuizResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
