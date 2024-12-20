
import 'package:prostuti/features/course/materials/test/model/test_model.dart';
import 'package:prostuti/features/course/materials/test/repository/test_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class MCQTestListViewmodel extends _$MCQTestListViewmodel {
  @override
  Future<List<TestDataList>> build() async {
    return await getMCQTestDetails();
  }

  Future<List<TestDataList>> getMCQTestDetails() async {
    // final String id = ref.watch(getCourseByIdProvider);
    final response = await ref
        .read(testRepoProvider)
        .getTestMCQList("676260b2be7381234b0bbe2c");

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
