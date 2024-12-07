import 'package:prostuti/features/course/course_details/repository/course_details_repo.dart';
import 'package:prostuti/features/course/course_list/viewmodel/get_course_by_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/course_details_model.dart';

part 'course_details_vm.g.dart';

@riverpod
class CourseDetailsViewmodel extends _$CourseDetailsViewmodel {
  @override
  FutureOr<CourseDetails> build() async {
    return await getCourseDetails();
  }

  Future<CourseDetails> getCourseDetails() async {
    final String id = ref.watch(getCourseByIdProvider);
    final response =
        await ref.read(courseDetailsRepoProvider).getCourseDetails(id);

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (course) {
        print(course);
        return course;
      },
    );
  }
}
