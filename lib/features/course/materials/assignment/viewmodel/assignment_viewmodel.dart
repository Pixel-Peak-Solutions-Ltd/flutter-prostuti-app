import 'package:prostuti/features/course/materials/assignment/model/assignment_model.dart';
import 'package:prostuti/features/course/materials/assignment/repository/assignment_repo.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/services/nav.dart';
import '../../../../auth/login/view/login_view.dart';

part 'assignment_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class AssignmentViewmodel extends _$AssignmentViewmodel {
  @override
  Future<List<AssignmentListData>> build() async {
    return await getCourseDetails();
  }

  Future<List<AssignmentListData>> getCourseDetails() async {
    // final String id = ref.watch(getCourseByIdProvider);
    final response = await ref
        .read(assignmentRepoProvider)
        .getAssignmentList("675556f0740a4834eef7d563");

    return response.fold(
      (l) {
        Nav().pushAndRemoveUntil(const LoginView());
        throw Exception(l.message);
      },
      (course) {
        return course.data ?? [];
      },
    );
  }
}
