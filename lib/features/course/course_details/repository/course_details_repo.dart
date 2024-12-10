// __brick__/repository/course_details_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

import '../../../../core/services/error_handler.dart';
import '../../../../core/services/error_response.dart';
import '../../../../core/services/nav.dart';
import '../../../auth/login/view/login_view.dart';
import '../model/course_details_model.dart';

part 'course_details_repo.g.dart';

@riverpod
CourseDetailsRepo courseDetailsRepo(CourseDetailsRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return CourseDetailsRepo(dioService);
}

class CourseDetailsRepo {
  final DioService _dioService;

  CourseDetailsRepo(this._dioService);

  Future<Either<ErrorResponse, CourseDetails>> getCourseDetails(
      String userId) async {
    final response = await _dioService.getRequest("/course/preview/$userId");

    if (response.statusCode == 200) {
      return Right(CourseDetails.fromJson(response.data));
    } else if (response.statusCode == 401) {
      Nav().pushAndRemoveUntil(const LoginView());
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
