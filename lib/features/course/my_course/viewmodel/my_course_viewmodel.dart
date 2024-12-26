import 'package:prostuti/features/course/my_course/model/my_course_model.dart';
import 'package:prostuti/features/course/my_course/repository/my_course_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_course_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class EnrolledCourseViewmodel extends _$EnrolledCourseViewmodel {
  @override
  Future<List<EnrolledCourseListData>> build() async {
    return await getEnrolledCourseList();
  }

  Future<List<EnrolledCourseListData>> getEnrolledCourseList() async {
    // final String id = ref.watch(getCourseByIdProvider);
    final response =
        await ref.read(myCourseRepoProvider).getEnrolledCourseList();

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (course) {
        return course.data!.data ?? [];
      },
    );
  }
}
