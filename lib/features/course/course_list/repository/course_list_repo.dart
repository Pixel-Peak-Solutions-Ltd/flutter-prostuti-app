// __brick__/repository/course_list_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:prostuti/features/course/course_list/model/course_list_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/error_handler.dart';
import '../../../../core/services/error_response.dart';

part 'course_list_repo.g.dart';

@riverpod
CourseListRepo courseListRepo(CourseListRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return CourseListRepo(dioService);
}

class CourseListRepo {
  final DioService _dioService;

  CourseListRepo(this._dioService);

  Future<Either<ErrorResponse, PublishedCourse>>
      getAllPublishedCourseList() async {
    final response =
        await _dioService.getRequest("/course/student-published-courses");

    if (response.statusCode == 200) {
      return Right(PublishedCourse.fromJson(response.data));
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
