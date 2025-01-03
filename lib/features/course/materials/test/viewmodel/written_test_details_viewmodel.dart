
import 'package:prostuti/features/course/materials/test/repository/test_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/written_test_details_model.dart';
import 'get_test_by_id.dart';

part 'written_test_details_viewmodel.g.dart';

@riverpod
class WrittenTestDetailsViewmodel extends _$WrittenTestDetailsViewmodel {
  @override
  FutureOr<WrittenTestDetails> build() async {
    return await getWrittenTestById();
  }

  Future<WrittenTestDetails> getWrittenTestById() async {
    final String id = ref.watch(getTestByIdProvider);
    final response = await ref.read(testRepoProvider).getWrittenTestById(id);

    return response.fold(
          (l) {
        throw Exception(l.message);
      },
          (writtenTest) {
        return writtenTest;
      },
    );
  }
}
