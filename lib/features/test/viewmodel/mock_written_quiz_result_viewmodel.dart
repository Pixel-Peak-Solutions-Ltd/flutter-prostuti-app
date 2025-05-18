import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/mcq_quiz_result_model.dart';
import '../model/mock_written_quiz_model.dart';
import '../model/written_quiz_result_model.dart';
import '../repository/mock_test_repo.dart';

part 'mock_written_quiz_result_viewmodel.g.dart';

@riverpod
class MockWrittenQuizResultViewmodel extends _$MockWrittenQuizResultViewmodel {
  @override
  Future<WrittenQuizResultModel?> build(String quizId) async {
    final repo = ref.read(mockTestRepoProvider);
    final response = await repo.getMockWrittenQuizResult(quizId: quizId);
    return response.fold(
          (l) => throw Exception(l.message),
          (r) => r,
    );
  }
}
