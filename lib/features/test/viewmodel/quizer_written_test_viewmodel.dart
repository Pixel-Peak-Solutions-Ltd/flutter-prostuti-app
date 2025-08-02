import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/mock_written_quiz_model.dart';
import '../repository/mock_test_repo.dart';

part 'quizer_written_test_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class QuizerWrittenTestViewmodel extends _$QuizerWrittenTestViewmodel {
  @override
  Future<MockWrittenQuizResponse?> build() async {
    // Initial State (You can trigger a default API call if needed)
    return null;
  }

  Future<MockWrittenQuizResponse?> createWrittenQuizer({
    required String questionType,
    required List<Map<String, dynamic>> subjects,
    required List<String> questionFilters,
    required int questionCount,
    required bool isNegativeMarking,
    required int time,
  }) async {
    state = const AsyncLoading();

    final payload = {
      "questionType": questionType,
      "subjects": subjects,
      "questionFilters":questionFilters,
      "questionCount": questionCount,
      "isNegativeMarking": isNegativeMarking,
      "time": time,
    };

    final response = await ref.read(mockTestRepoProvider).createWrittenMockQuiz(payload: payload);

    return response.fold(
          (l) => throw Exception(l.message),
          (data) {
        state = AsyncData(data);
        return data;
      },
    );
  }
}
