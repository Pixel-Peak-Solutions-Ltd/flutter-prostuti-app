import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/mock_quiz_model.dart';
import '../repository/mock_test_repo.dart';

part 'quizer_test_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class QuizerTestViewmodel extends _$QuizerTestViewmodel {
  @override
  Future<MockQuizResponse?> build() async {
    // Initial State (You can trigger a default API call if needed)
    return null;
  }

  Future<MockQuizResponse?> createMCQQuizer({
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

    final response = await ref.read(mockTestRepoProvider).createMCQMockQuiz(payload: payload);

    return response.fold(
          (l) {
        state = const AsyncData(null);
        throw Exception(l.message);
      },
          (data) {
        state = AsyncData(data);
        return data;
      },
    );
  }
}
