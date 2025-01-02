
import 'package:prostuti/features/course/materials/test/model/test_model.dart';
import 'package:prostuti/features/course/materials/test/repository/test_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../course_list/viewmodel/get_course_by_id.dart';

part 'test_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class MCQTestListViewmodel extends _$MCQTestListViewmodel {
  @override
  Future<List<TestDataList>> build() async {
    return await getMCQTestDetails();
  }

  Future<List<TestDataList>> getMCQTestDetails() async {
    final String id = ref.watch(getCourseByIdProvider);
    final response = await ref
        .read(testRepoProvider)
        .getTestMCQList(id);

    return response.fold(
          (l) {
        throw Exception(l.message);
      },
          (course) {
        return course.data?.data ?? [];
      },
    );
  }
}
