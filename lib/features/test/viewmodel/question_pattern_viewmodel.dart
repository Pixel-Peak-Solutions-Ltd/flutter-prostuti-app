import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/question_pattern_model.dart';
import '../repository/question_pattern_repo.dart';

part 'question_pattern_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class QuestionPatternViewmodel extends _$QuestionPatternViewmodel {
  @override
  Future<QuestionPattern?> build() async {
    // Initial state: no data
    return null;
  }

  Future<QuestionPattern?> loadFirstQuestionPattern({
    String? categoryType,
    String? categoryDivision,
    String? categoryUniversityType,
    String? categoryUniversityName,
    String? categorySubject,
  }) async {
    state = const AsyncLoading();

    try {
      final patterns = await ref.read(questionPatternRepoProvider).fetchQuestionPatterns(
        categoryType: categoryType,
        categoryDivision: categoryDivision,
        categoryUniversityType: categoryUniversityType,
        categoryUniversityName: categoryUniversityName,
        categorySubject: categorySubject,
      );

      final first = patterns.isNotEmpty ? patterns.first : null;
      state = AsyncData(first);
      return first;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
