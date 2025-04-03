import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/flashcard_repo.dart';

part 'flashcard_favourite_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class FavoriteFlashcards extends _$FavoriteFlashcards {
  Set<String> _favoriteIds = {};

  @override
  Future<Set<String>> build() async {
    print("Building FavoriteFlashcards provider");
    await _loadFavorites();
    return _favoriteIds;
  }

  Future<void> _loadFavorites() async {
    print("Loading favorites from API");
    final result =
        await ref.read(flashcardRepoProvider).getFavoriteFlashcardItems();

    result.fold(
      (error) {
        // Handle error
        print("Error loading favorites: ${error.message}");
        _favoriteIds = {};
      },
      (favoriteIds) {
        print("Loaded favorites: $favoriteIds");
        _favoriteIds = Set<String>.from(favoriteIds);
      },
    );
  }

  Future<bool> toggleFavorite(String itemId) async {
    try {
      print('Toggling favorite for item: $itemId');
      print('Current favorites before toggle: $_favoriteIds');

      // First optimistically update the UI
      final newFavorites = Set<String>.from(_favoriteIds);
      if (newFavorites.contains(itemId)) {
        newFavorites.remove(itemId);
      } else {
        newFavorites.add(itemId);
      }

      // Update state immediately for responsive UI
      state = AsyncValue.data(newFavorites);

      // Then make the API call
      final result = await ref
          .read(flashcardRepoProvider)
          .toggleFavoriteFlashcardItem(itemId);

      return result.fold(
        (error) {
          // On error, revert to previous state
          print('Error toggling favorite: ${error.message}');
          state = AsyncValue.data(_favoriteIds);
          return false;
        },
        (success) {
          // On success, update local state to match server
          if (_favoriteIds.contains(itemId)) {
            _favoriteIds.remove(itemId);
          } else {
            _favoriteIds.add(itemId);
          }

          print('Favorite toggled successfully. New favorites: $_favoriteIds');
          return true;
        },
      );
    } catch (e) {
      print('Exception in toggleFavorite: $e');
      return false;
    }
  }

  bool isFavorite(String itemId) {
    final currentState = state;
    if (currentState is AsyncData<Set<String>>) {
      final data = currentState.value;
      final result = data.contains(itemId);
      print('Checking if $itemId is favorite: $result');
      return result;
    }
    return false;
  }

  // Force refresh from server
  Future<void> refreshFavorites() async {
    state = const AsyncValue.loading();
    await _loadFavorites();
    state = AsyncValue.data(_favoriteIds);
  }
}
