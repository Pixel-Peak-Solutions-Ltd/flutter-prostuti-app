import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/test/model/mcq_quiz_result_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/mock_quiz_model.dart';
import '../model/mock_written_quiz_model.dart';
import '../model/quiz_submit_model.dart';
import '../model/written_quiz_result_model.dart';

part 'mock_test_repo.g.dart';

@riverpod
MockTestRepo mockTestRepo(MockTestRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return MockTestRepo(dioService);
}

class MockTestRepo {
  final DioService _dioService;

  MockTestRepo(this._dioService);

  Future<Either<ErrorResponse, MockQuizResponse>> createMCQMockQuiz({
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

  Future<Either<ErrorResponse, MockWrittenQuizResponse>> createWrittenMockQuiz({
    required Map<String, dynamic> payload,
  }) async {
    final response = await _dioService.postRequest("/quiz/create-mock-quiz", payload);

    if (response.statusCode == 200) {
      return Right(MockWrittenQuizResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, QuizSubmitModel>> submitMockQuiz({
    required String quizId,
    required Map<String, dynamic> payload,
    bool isSegmentTest = false,
  }) async {
    final String endpoint = isSegmentTest
        ? "/quiz/submit-segment-quiz/$quizId"
        : "/quiz/submit-mock-quiz/$quizId";

    final response = await _dioService.patchRequest(endpoint, data: payload);

    if (response.statusCode == 200) {
      return Right(QuizSubmitModel.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, MCQQuizResultModel>> getMockMCQQuizResult({
    required String quizId,
  }) async {
    final response = await _dioService.getRequest("/quiz/single-quiz/$quizId");

    if (response.statusCode == 200) {
      return Right(MCQQuizResultModel.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, WrittenQuizResultModel>> getMockWrittenQuizResult({
    required String quizId,
  }) async {
    final response = await _dioService.getRequest("/quiz/single-quiz/$quizId");

    if (response.statusCode == 200) {
      return Right(WrittenQuizResultModel.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
