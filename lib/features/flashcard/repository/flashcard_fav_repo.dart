import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/flashcard/model/flashcard_details_model.dart';
import 'package:prostuti/features/flashcard/repository/flashcard_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flashcard_fav_repo.g.dart';

// Enhanced provider for favorite flashcard items with full details
@riverpod
class FavoriteFlashcardDetails extends _$FavoriteFlashcardDetails {
  @override
  Future<List<FlashcardItem>> build() async {
    final dioService = ref.read(dioServiceProvider);

    try {
      // Get the raw response directly to access the full item data
      final response =
          await dioService.getRequest("/flashcard/favorite-flashcard-items");

      if (response.statusCode == 200) {
        final List<dynamic> itemsData = response.data['data'] ?? [];

        // Create FlashcardItem objects from the raw API data
        final List<FlashcardItem> items =
            itemsData.map<FlashcardItem>((itemData) {
          return FlashcardItem(
            sId: itemData['_id'],
            flashcardId: itemData['flashcardId'],
            term: itemData['term'],
            answer: itemData['answer'],
            viewCount: itemData['viewCount'],
            isFavourite: true,
            // These are favorites by definition
            isKnown: itemData['isKnown'] ?? false,
            isLearned: itemData['isLearned'] ?? false,
          );
        }).toList();

        return items;
      } else {
        print('Error fetching favorite items: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception in FavoriteFlashcardDetails: $e');
      return [];
    }
  }

  // Refresh the favorite flashcard details
  Future<void> refreshFavorites() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
