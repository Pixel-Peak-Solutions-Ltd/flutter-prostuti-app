
import 'package:prostuti/features/course/materials/test/repository/test_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/mcq_test_details_model.dart';
import '../model/test_history_model.dart';
import 'get_test_by_id.dart';

part 'get_mcq_test_history.g.dart';

@riverpod
class GetMCQTestHistory extends _$GetMCQTestHistory {
  @override
  FutureOr<TestHistory> build(String id) async {
    return await getMCQTestHistoryById(id);
  }

  Future<TestHistory> getMCQTestHistoryById(String id) async {
    final response =
    await ref.read(testRepoProvider).getMCQTestHistoryById(id);

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
