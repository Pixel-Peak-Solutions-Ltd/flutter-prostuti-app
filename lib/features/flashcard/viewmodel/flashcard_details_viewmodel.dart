import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/flashcard_details_model.dart';
import '../repository/flashcard_detail_repo.dart';

part 'flashcard_details_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class FlashcardDetailNotifier extends _$FlashcardDetailNotifier {
  @override
  Future<FlashcardDetail> build(String flashcardId) async {
    return _fetchFlashcardDetail(flashcardId);
  }

  Future<FlashcardDetail> _fetchFlashcardDetail(String flashcardId) async {
    final response = await ref
        .read(flashcardDetailRepoProvider)
        .getFlashcardDetail(flashcardId);

    return response.fold(
      (error) => throw Exception(error.message),
      (flashcardDetailResponse) {
        if (flashcardDetailResponse.data == null) {
          throw Exception("Failed to load flashcard details");
        }
        return flashcardDetailResponse.data!;
      },
    );
  }

  // Method to toggle favorite status for a flashcard item
  Future<void> toggleFavorite(String itemId) async {
    final currentState = state;
    if (currentState is AsyncData<FlashcardDetail>) {
      final flashcardDetail = currentState.value;
      final items = flashcardDetail.items;

      if (items != null) {
        final index = items.indexWhere((item) => item.sId == itemId);
        if (index != -1) {
          final item = items[index];
          final newItems = List<FlashcardItem>.from(items);
          newItems[index] = FlashcardItem(
            sId: item.sId,
            flashcardId: item.flashcardId,
            term: item.term,
            answer: item.answer,
            viewCount: item.viewCount,
            isFavourite: !(item.isFavourite ?? false),
            isKnown: item.isKnown,
            isLearned: item.isLearned,
          );

          // Update the state optimistically
          state = AsyncData(FlashcardDetail(
            sId: flashcardDetail.sId,
            title: flashcardDetail.title,
            visibility: flashcardDetail.visibility,
            categoryId: flashcardDetail.categoryId,
            studentId: flashcardDetail.studentId,
            isApproved: flashcardDetail.isApproved,
            createdAt: flashcardDetail.createdAt,
            updatedAt: flashcardDetail.updatedAt,
            iV: flashcardDetail.iV,
            items: newItems,
          ));

          // Call the API to update the backend
          // This is where you would call your repository to update the status
          // For now, we'll just update the UI
        }
      }
    }
  }

  // Methods for card interaction logic to be implemented later
  void markAsKnown(String itemId) {
    // Will be implemented later
  }

  void markAsLearned(String itemId) {
    // Will be implemented later
  }

  void incrementViewCount(String itemId) {
    // Will be implemented later
  }
}
