
import 'package:prostuti/features/course/materials/test/model/test_model.dart';
import 'package:prostuti/features/course/materials/test/repository/test_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../course_list/viewmodel/get_course_by_id.dart';
import '../model/written_test_model.dart';

part 'written_test_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class WrittenTestListViewmodel extends _$WrittenTestListViewmodel {
  @override
  Future<List<WrittenTestDataList>> build() async {
    return await getCourseDetails();
  }

  Future<List<WrittenTestDataList>> getCourseDetails() async {
    final String id = ref.watch(getCourseByIdProvider);
    final response = await ref
        .read(testRepoProvider)
        .getTestWrittenList(id);

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
