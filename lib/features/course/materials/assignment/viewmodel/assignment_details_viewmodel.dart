import 'package:prostuti/features/course/materials/assignment/model/assignment_details.dart';
import 'package:prostuti/features/course/materials/assignment/repository/assignment_repo.dart';
import 'package:prostuti/features/course/materials/assignment/viewmodel/get_assignment_by_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assignment_details_viewmodel.g.dart';

@riverpod
class AssignmentDetailsViewmodel extends _$AssignmentDetailsViewmodel {
  @override
  FutureOr<AssignmentDetails> build() async {
    return await getRecordClassById();
  }

  Future<AssignmentDetails> getRecordClassById() async {
    final String id = ref.watch(getAssignmentByIdProvider);
    final response =
        await ref.read(assignmentRepoProvider).getAssignmentById(id);

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (assignment) {
        return assignment;
      },
    );
  }
}
