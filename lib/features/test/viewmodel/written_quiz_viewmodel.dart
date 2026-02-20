import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/mock_written_quiz_model.dart';
import '../repository/mock_test_repo.dart';
import '../widgets/subject_dropdown.dart';

part 'written_quiz_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class WrittenQuizViewmodel extends _$WrittenQuizViewmodel {
  @override
  Future<MockWrittenQuizResponse?> build() async {
    // Initial State (You can trigger a default API call if needed)
    return null;
  }

  Future<MockWrittenQuizResponse?> createMockQuiz({
    required String questionType,
    required List<Map<String, dynamic>> subjects,
    required int questionCount,
    int? mcqCount,
    int? writtenCount,
    required bool isNegativeMarking,
    required int time,
  }) async {
    state = const AsyncLoading();

    final payload = {
      "questionType": questionType,
      "subjects": subjects,
      "questionCount": questionCount,
      if (mcqCount != null) "mcqCount": mcqCount,
      if (writtenCount != null) "writtenCount": writtenCount,
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
