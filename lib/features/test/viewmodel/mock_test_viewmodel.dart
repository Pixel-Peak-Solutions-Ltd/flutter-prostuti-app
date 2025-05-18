import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/mock_quiz_model.dart';
import '../repository/mock_test_repo.dart';

part 'mock_test_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class MockTestViewmodel extends _$MockTestViewmodel {
  @override
  Future<MockQuizResponse?> build() async {
    // Initial State (You can trigger a default API call if needed)
    return null;
  }

  Future<MockQuizResponse?> createMockQuiz({
    required String questionType,
    required List<String> subjects,
    required int questionCount,
    required bool isNegativeMarking,
    required int time,
  }) async {
    state = const AsyncLoading();

    final payload = {
      "questionType": questionType,
      "subjects": subjects,
      "questionCount": questionCount,
      "isNegativeMarking": isNegativeMarking,
      "time": time,
    };

    final response = await ref.read(mockTestRepoProvider).createMCQMockQuiz(payload: payload);

    return response.fold(
          (l) => throw Exception(l.message),
          (data) {
        state = AsyncData(data);
        return data;
        },
    );
  }
}
