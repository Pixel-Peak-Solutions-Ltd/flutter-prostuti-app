import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This provider tracks study sessions for a specific flashcard
final flashcardStudySessionsProvider = StateNotifierProvider.family<
    FlashcardStudySessionsNotifier, AsyncValue<int>, String>(
  (ref, flashcardId) => FlashcardStudySessionsNotifier(flashcardId),
);

class FlashcardStudySessionsNotifier extends StateNotifier<AsyncValue<int>> {
  final String flashcardId;

  FlashcardStudySessionsNotifier(this.flashcardId)
      : super(const AsyncValue.loading()) {
    _loadStudySessions();
  }

  Future<void> _loadStudySessions() async {
    try {
      // Get the current day as a string (YYYY-MM-DD format)
      final today = DateTime.now().toString().split(' ')[0];

      // Create a unique key for storing the count for this flashcard on this day
      final key = 'flashcard_study_count_${flashcardId}_$today';

      // Load from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final count = prefs.getInt(key) ?? 0;

      state = AsyncValue.data(count);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // This method should be called when the user actually navigates to the study view
  Future<void> recordStudySession() async {
    // Get the current count
    final currentCount = state.value ?? 0;

    // Optimistically update the UI
    state = AsyncValue.data(currentCount + 1);

    try {
      // Get the current day as a string (YYYY-MM-DD format)
      final today = DateTime.now().toString().split(' ')[0];

      // Create a unique key for storing the count
      final key = 'flashcard_study_count_${flashcardId}_$today';

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, currentCount + 1);
    } catch (e, stackTrace) {
      // On failure, revert to the previous count
      state = AsyncValue.data(currentCount);
    }
  }
}
