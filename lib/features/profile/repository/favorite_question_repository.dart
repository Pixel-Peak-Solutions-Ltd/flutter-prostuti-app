import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/dio_service.dart';
import '../model/favorite_question_model.dart';
part 'favorite_question_repository.g.dart';

class FavoriteQuestionRepository {
  final DioService _dioService;

  FavoriteQuestionRepository(this._dioService);

  Future<FavoriteQuestionModel> getFavoriteQuestions() async {
    try {
      final response = await _dioService.getRequest('/favourite/question');
      return FavoriteQuestionModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load favorite questions: $e');
    }
  }

/*
  Future<void> toggleFavoriteQuestion(String questionId) async {
    try {
      await _dioService.postRequest(
          '/api/student/favorites/questions/toggle',
          {'question_id': questionId}
      );
    } catch (e) {
      throw Exception('Failed to toggle favorite question: $e');
    }
  }
*/
}

@riverpod
FavoriteQuestionRepository favoriteQuestionRepository(FavoriteQuestionRepositoryRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return FavoriteQuestionRepository(dioService);
}