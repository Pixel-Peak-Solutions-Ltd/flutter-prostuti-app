import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/favorite_question_model.dart';
import '../repository/favorite_question_repository.dart';

part 'favorite_question_viewmodel.g.dart';

@riverpod
class FavoriteQuestions extends _$FavoriteQuestions {
  @override
  Future<List<FavouriteQuestions>> build() async {
    return _fetchFavoriteQuestions();
  }

  Future<List<FavouriteQuestions>> _fetchFavoriteQuestions() async {
    try {
      final repository = ref.read(favoriteQuestionRepositoryProvider);
      final response = await repository.getFavoriteQuestions();

      if (response.success == true &&
          response.data != null &&
          response.data!.isNotEmpty) {
        return response.data![0].favouriteQuestions ?? [];
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load favorite questions: $e');
    }
  }

  Future<void> refreshFavorites() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchFavoriteQuestions);
  }

  /*Future<void> toggleFavorite(String questionId) async {
    try {
      final repository = ref.read(favoriteQuestionRepositoryProvider);
      await repository.toggleFavoriteQuestion(questionId);
      refreshFavorites();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }*/
}