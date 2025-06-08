import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/core/services/dio_service.dart';

import '../model/question_pattern_model.dart';

part 'question_pattern_repo.g.dart';

@riverpod
QuestionPatternRepo questionPatternRepo(QuestionPatternRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return QuestionPatternRepo(dioService);
}

class QuestionPatternRepo {
  final DioService _dioService;

  QuestionPatternRepo(this._dioService);

  Future<List<QuestionPattern>> fetchQuestionPatterns({
    String? categoryType,
    String? categoryDivision,
    String? categoryUniversityType,
    String? categoryUniversityName,
    String? categorySubject,
  }) async {
    const String endpoint = '/question-pattern/all-question-pattern';

    final Map<String, String> params = {
      if (categoryType != null) 'categoryType': categoryType,
      if (categoryDivision != null) 'categoryDivision': categoryDivision,
      if (categoryUniversityType != null) 'categoryUniversityType': categoryUniversityType,
      if (categoryUniversityName != null) 'categoryUniversityName': categoryUniversityName,
      if (categorySubject != null) 'categorySubject': categorySubject,
    };

    final response = await _dioService.getRequest(endpoint, queryParameters: params);

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> rawData = response.data['data']['data'] ?? [];
      return rawData.map((json) => QuestionPattern.fromJson(json)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load question patterns');
    }
  }
}
