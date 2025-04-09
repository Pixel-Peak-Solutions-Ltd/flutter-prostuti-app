import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/features/leaderboard/model/leaderboard_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/error_handler.dart';
import '../../../core/services/error_response.dart';

part 'leaderboard_repo.g.dart';

@riverpod
LeaderboardRepo leaderboardRepo(LeaderboardRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return LeaderboardRepo(dioService);
}

class LeaderboardRepo {
  final DioService _dioService;

  LeaderboardRepo(this._dioService);

  Future<Either<ErrorResponse, LeaderboardResponse>> getGlobalLeaderboard({
    int page = 1,
    int limit = 10,
  }) async {
    final queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final response = await _dioService.getRequest(
      "/leaderboard/global",
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      return Right(LeaderboardResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, LeaderboardResponse>> getCourseLeaderboard({
    required String courseId,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final response = await _dioService.getRequest(
      "/leaderboard/course/$courseId",
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      return Right(LeaderboardResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
