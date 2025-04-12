// course_review_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/error_handler.dart';
import '../../../../core/services/error_response.dart';
import '../model/course_review_model.dart';

part 'course_review_repo.g.dart';

@riverpod
CourseReviewRepo courseReviewRepo(CourseReviewRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return CourseReviewRepo(dioService);
}

class CourseReviewRepo {
  final DioService _dioService;

  CourseReviewRepo(this._dioService);

  Future<Either<ErrorResponse, CourseReviewResponse>> getCourseReviews(
      String courseId) async {
    final response = await _dioService.getRequest("/course-review/$courseId");

    if (response.statusCode == 200) {
      return Right(CourseReviewResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, CourseReviewResponse>> createCourseReview(
      Map<String, dynamic> reviewData) async {
    final response = await _dioService.postRequest(
      "/course-review",
      reviewData,
    );

    if (response.statusCode == 200) {
      return Right(CourseReviewResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
