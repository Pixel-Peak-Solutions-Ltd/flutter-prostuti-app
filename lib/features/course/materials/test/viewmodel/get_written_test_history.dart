
import 'package:prostuti/features/course/materials/test/model/written_result_model.dart';
import 'package:prostuti/features/course/materials/test/repository/test_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'get_test_by_id.dart';

part 'get_written_test_history.g.dart';

@riverpod
class GetWrittenTestHistory extends _$GetWrittenTestHistory {
  @override
  FutureOr<WrittenResultModel> build() async {
    return await getWrittenTestHistoryById();
  }

  Future<WrittenResultModel> getWrittenTestHistoryById() async {
    final String id = ref.watch(getTestByIdProvider);
    final response =
    await ref.read(testRepoProvider).getWrittenTestHistoryById(id);

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
