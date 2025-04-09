import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/flashcard/model/flashcard_details_model.dart';
import 'package:prostuti/features/flashcard/viewmodel/flashcard_favourite_viewmodel.dart';
import 'package:prostuti/features/flashcard/widgets/flashcard_card.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../repository/flashcard_fav_repo.dart';

// We'll use the enhanced provider from flashcard_favorite_repository.dart

class FavoriteItemsView extends ConsumerStatefulWidget {
  const FavoriteItemsView({super.key});

  @override
  FavoriteItemsViewState createState() => FavoriteItemsViewState();
}

class FavoriteItemsViewState extends ConsumerState<FavoriteItemsView>
    with SingleTickerProviderStateMixin, CommonWidgets {
  late PageController _pageController;
  int _currentTabIndex = 0;
  final SwipableStackController _controller = SwipableStackController();
  final FlutterTts flutterTts = FlutterTts();
  final List<GlobalKey<FlipCardState>> _cardKeys = [];
  bool _showAnswer = false;
  int _currentIndex = 0;

  // Colors for the flashcards
  final List<Color> _cardColors = [
    const Color(0xFFC084FC),
    const Color(0xFF656058),
    const Color(0xFFF97316),
    const Color(0xFF652E07),
    const Color(0xFF534D65),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentTabIndex);
    _initTts();

    // Load favorites when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteFlashcardsProvider.notifier).refreshFavorites();
    });
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("bn-BD"); // Bengali language
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _toggleFavorite(String itemId) {
    // Call the API through the provider
    ref.read(favoriteFlashcardsProvider.notifier).toggleFavorite(itemId);
  }

  void _onSwipeCompleted(int index, SwipeDirection direction) {
    setState(() {
      _currentIndex = index;
      _showAnswer = false;
    });
  }

  Color _getCardColor(int index) {
    return _cardColors[index % _cardColors.length];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void _nextCard() {
    if (_showAnswer) {
      setState(() {
        _showAnswer = false;
      });
    }
    _controller.next(swipeDirection: SwipeDirection.right);
  }

  void _previousCard() {
    if (_showAnswer) {
      setState(() {
        _showAnswer = false;
      });
    }
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _changeTab(int index) {
    setState(() {
      _currentTabIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context.l10n!.favoriteItems),
      body: Column(
        children: [
          // Tab buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _changeTab(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSecondary,
                          width: 2,
                        ),
                        color: _currentTabIndex == 0
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          context.l10n!.flashcards,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: _currentTabIndex == 0
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _changeTab(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSecondary,
                          width: 2,
                        ),
                        color: _currentTabIndex == 1
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          context.l10n!.questionHint,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: _currentTabIndex == 1
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              // Disable swiping between tabs
              onPageChanged: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
              children: [
                // Favorite Flashcards Tab
                _buildFavoriteFlashcardsTab(),

                // Questions Tab (placeholder)
                Center(child: Text(context.l10n!.noActivitiesForDay)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteFlashcardsTab() {
    // Watch the favorite flashcard details provider
    final itemsAsync = ref.watch(favoriteFlashcardDetailsProvider);

    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text(context.l10n!.noFlashcardItems),
          );
        }

        // Ensure we have enough card keys
        if (_cardKeys.length < items.length) {
          for (int i = _cardKeys.length; i < items.length; i++) {
            _cardKeys.add(GlobalKey<FlipCardState>());
          }
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                    onPressed: _previousCard,
                  ),
                  Text(
                    context.l10n!.swipe,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  InkWell(
                    onTap: _nextCard,
                    child: SvgPicture.asset(
                      "assets/icons/flashcard_next.svg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildStackedCards(items),
              ),
            ),
          ],
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          semanticsLabel: context.l10n!.loading,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      error: (error, stack) => Center(
        child: Text('${context.l10n!.error}: ${error.toString()}'),
      ),
    );
  }

  Widget _buildStackedCards(List<FlashcardItem> items) {
    return Stack(
      children: [
        // Background cards
        ..._buildBackgroundCards(items),

        // Main swipable stack
        SwipableStack(
          controller: _controller,
          onSwipeCompleted: _onSwipeCompleted,
          overlayBuilder: (context, properties) {
            // Show overlay instructions when swiping
            final direction = properties.direction;
            if (direction == null) return const SizedBox.shrink();

            if (direction == SwipeDirection.left) {
              return _buildSwipeOverlay(
                context.l10n!.swipeLeftToLearn,
                direction,
                const Color(0xFF60A5FA),
              );
            } else if (direction == SwipeDirection.right) {
              return _buildSwipeOverlay(
                context.l10n!.swipeRightToKnow,
                direction,
                const Color(0xFF60A5FA),
              );
            }

            return const SizedBox.shrink();
          },
          builder: (context, properties) {
            final index = properties.index;
            final actualIndex = index % items.length;
            final FlashcardItem item = items[actualIndex];

            // Create a unique key for each position
            final key = GlobalKey<FlipCardState>();

            // All items here are favorites
            return FlashCard(
              frontText: item.term ?? "Loading...",
              backText: item.answer ?? "Loading...",
              flipKey: key,
              isFavorite: true,
              // It's already a favorite
              onTts: () {
                final textToSpeak = key.currentState?.isFront == true
                    ? item.term ?? ""
                    : item.answer ?? "";
                _speak(textToSpeak);
              },
              onFavorite: () => _toggleFavorite(item.sId!),
              backgroundColor: _getCardColor(actualIndex),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildBackgroundCards(List<dynamic> items) {
    List<Widget> backgroundCards = [];

    // Only build background cards if there are more cards coming up
    if (items.length > _currentIndex + 1) {
      // Add the next 2 cards (or as many as available)
      for (int i = 1; i <= 2; i++) {
        if (_currentIndex + i < items.length) {
          final nextIndex = (_currentIndex + i) % items.length;

          // Calculate decreasing sizes and offsets for stacked effect
          final topOffset =
              -50.0 * i; // Each card is peeking out 50 pixels from the top
          final scale = 1.0 - (0.03 * i); // Each card is slightly smaller

          backgroundCards.add(
            Positioned(
              top: topOffset,
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: 0.8 - (0.1 * i),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      color: _getCardColor(nextIndex),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    // Return in reverse order so the card closest to top is drawn last
    return backgroundCards.reversed.toList();
  }

  Widget _buildSwipeOverlay(
      String text, SwipeDirection direction, Color color) {
    return Center(
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              direction == SwipeDirection.left
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 60,
            ),
            const Gap(16),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
