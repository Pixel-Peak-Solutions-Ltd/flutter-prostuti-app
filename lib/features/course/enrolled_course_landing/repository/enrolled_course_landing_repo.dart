// __brick__/repository/enrolled_course_landing_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enrolled_course_landing_repo.g.dart';

@riverpod
EnrolledCourseLandingRepo enrolledCourseLandingRepo(
    EnrolledCourseLandingRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return EnrolledCourseLandingRepo(dioService);
}

class EnrolledCourseLandingRepo {
  final DioService _dioService;

  EnrolledCourseLandingRepo(this._dioService);

  Future<bool> markAsComplete(payload) async {
    final response =
        await _dioService.postRequest("/progress/mark-as-complete", payload);

    if (response.statusCode == 200) {
      return response.data['success'];
    } else {
      return response.data['success'];
    }
  }

  Future<List> getMaterialComplete(String courseId) async {
    final response =
        await _dioService.getRequest("/progress/student-progress/$courseId");

    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      return [];
    }
  }
}
