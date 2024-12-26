// __brick__/repository/my_course_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/course/my_course/model/my_course_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/error_handler.dart';

part 'my_course_repo.g.dart';

@riverpod
MyCourseRepo myCourseRepo(MyCourseRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return MyCourseRepo(dioService);
}

class MyCourseRepo {
  final DioService _dioService;

  MyCourseRepo(this._dioService);

  Future<Either<ErrorResponse, EnrolledCourseList>>
      getEnrolledCourseList() async {
    final response = await _dioService.getRequest("/enroll-course?limit=0");

    if (response.statusCode == 200) {
      return Right(EnrolledCourseList.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
