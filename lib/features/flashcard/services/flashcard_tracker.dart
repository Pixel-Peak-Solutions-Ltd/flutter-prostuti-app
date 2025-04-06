import 'package:flutter/material.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../model/flashcard_details_model.dart';
import '../view/flashcard_complete_view.dart';

class FlashcardStudyTracker {
  // Keep track of counts
  int knownCount = 0;
  int learnCount = 0;
  int totalProcessedCards = 0;

  // Collection of card IDs that have been processed
  final Set<String> processedCardIds = {};

  // Record a swipe action
  void recordSwipe(String cardId, SwipeDirection direction) {
    // Only count each card once
    if (!processedCardIds.contains(cardId)) {
      processedCardIds.add(cardId);
      totalProcessedCards++;

      // Track direction
      if (direction == SwipeDirection.right) {
        knownCount++;
      } else if (direction == SwipeDirection.left) {
        learnCount++;
      }
    }
  }

  // Check if all cards have been processed
  bool allCardsProcessed(List<FlashcardItem> items) {
    return totalProcessedCards >= items.length;
  }

  // Navigate to completion screen if all cards are done
  void checkCompletion(BuildContext context, FlashcardDetail flashcardDetail,
      String flashcardId, String flashcardTitle) {
    final items = flashcardDetail.items ?? [];

    if (allCardsProcessed(items)) {
      // Navigate to the completion view
      Nav().pushReplacement(
        FlashcardCompletionView(
          flashcardId: flashcardId,
          flashcardTitle: flashcardTitle,
          knownCount: knownCount,
          learnCount: learnCount,
          totalCards: items.length,
          flashcardDetail: flashcardDetail,
        ),
      );
    }
  }

  // Reset the tracker
  void reset() {
    knownCount = 0;
    learnCount = 0;
    totalProcessedCards = 0;
    processedCardIds.clear();
  }
}
