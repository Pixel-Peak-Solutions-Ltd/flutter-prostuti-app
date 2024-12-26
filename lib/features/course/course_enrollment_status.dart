import 'package:prostuti/features/course/my_course/repository/my_course_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'course_list/viewmodel/get_course_by_id.dart';

part 'course_enrollment_status.g.dart';

@riverpod
class CourseEnrollmentStatus extends _$CourseEnrollmentStatus {
  @override
  Future<bool> build() async {
    return await _isCourseEnrolled(); // Pass the course ID you want to check
  }

  Future<bool> _isCourseEnrolled() async {
    final id = ref.watch(getCourseByIdProvider);
    final response = await ref
        .read(myCourseRepoProvider)
        .getEnrolledCourseList(); // Make sure this gets the response with the 'data' list

    return response.fold(
      (l) => throw Exception(l.message), // Handle error case
      (r) {
        // Loop through the courses and check if course_id._id matches
        final isEnrolled = r.data!.data!.any((course) {
          return course.courseId!.sId == id;
        });

        return isEnrolled;
      },
    );
  }
}
