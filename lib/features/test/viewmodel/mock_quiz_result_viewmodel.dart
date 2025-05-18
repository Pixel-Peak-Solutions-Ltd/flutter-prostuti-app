import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/mcq_quiz_result_model.dart';
import '../repository/mock_test_repo.dart';

part 'mock_quiz_result_viewmodel.g.dart';

@riverpod
class MockQuizResultViewmodel extends _$MockQuizResultViewmodel {
  @override
  Future<MCQQuizResultModel?> build(String quizId) async {
    final repo = ref.read(mockTestRepoProvider);
    final response = await repo.getMockQuizResult(quizId: quizId);
    return response.fold(
          (l) => throw Exception(l.message),
          (r) => r,
    );
  }
}
