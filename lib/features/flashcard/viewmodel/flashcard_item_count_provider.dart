import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flashcard_details_viewmodel.dart';

// Simple provider to get item count for a specific flashcard ID
final flashcardItemCountProvider = FutureProvider.family<int, String>(
  (ref, flashcardId) async {
    try {
      // Fetch the flashcard details
      final flashcardDetail = await ref.watch(
        flashcardDetailNotifierProvider(flashcardId).future,
      );

      // Return the item count
      return flashcardDetail.items?.length ?? 0;
    } catch (e) {
      // Handle errors
      return 0; // Return 0 as fallback
    }
  },
);
