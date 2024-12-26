import 'package:prostuti/features/course/materials/assignment/model/assignment_model.dart';
import 'package:prostuti/features/course/materials/assignment/repository/assignment_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../course_list/viewmodel/get_course_by_id.dart';

part 'assignment_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class AssignmentViewmodel extends _$AssignmentViewmodel {
  @override
  Future<List<AssignmentListData>> build() async {
    return await getCourseDetails();
  }

  Future<List<AssignmentListData>> getCourseDetails() async {
    final String id = ref.watch(getCourseByIdProvider);
    final response =
        await ref.read(assignmentRepoProvider).getAssignmentList(id);

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (course) {
        return course.data ?? [];
      },
    );
  }
}
