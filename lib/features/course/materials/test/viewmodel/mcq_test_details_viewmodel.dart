
import 'package:prostuti/features/course/materials/test/repository/test_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/mcq_test_details_model.dart';
import 'get_test_by_id.dart';

part 'mcq_test_details_viewmodel.g.dart';

@riverpod
class MCQTestDetailsViewmodel extends _$MCQTestDetailsViewmodel {
  @override
  FutureOr<MCQTestDetails> build() async {
    return await getMCQTestById();
  }

  Future<MCQTestDetails> getMCQTestById() async {
    final String id = ref.watch(getTestByIdProvider);
    final response =
    await ref.read(testRepoProvider).getMCQTestById(id);

    return response.fold(
          (l) {
        throw Exception(l.message);
      },
          (mcqTest) {
        return mcqTest;
      },
    );
  }
}
