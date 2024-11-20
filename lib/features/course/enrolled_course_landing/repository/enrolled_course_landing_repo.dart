// __brick__/repository/enrolled_course_landing_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'enrolled_course_landing_repo.g.dart';

@riverpod
EnrolledCourseLandingRepo enrolledCourseLandingRepo(EnrolledCourseLandingRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return EnrolledCourseLandingRepo(dioService);
}

class EnrolledCourseLandingRepo {
final DioService _dioService;

EnrolledCourseLandingRepo(this._dioService);
}