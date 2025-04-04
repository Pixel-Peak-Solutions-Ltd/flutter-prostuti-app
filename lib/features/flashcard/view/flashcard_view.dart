import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/flashcard/view/create_flashcard_view.dart';
import 'package:prostuti/features/flashcard/view/flashcard_study_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/services/size_config.dart';
import '../model/flashcard_model.dart';
import '../viewmodel/flashcard_viewmodel.dart';
import '../widgets/flashcard_empty_state.dart';
import '../widgets/flashcard_header.dart';
import '../widgets/flashcard_item.dart';
import '../widgets/flashcard_search_container.dart';

class FlashcardView extends ConsumerStatefulWidget {
  const FlashcardView({super.key});

  @override
  FlashcardViewState createState() => FlashcardViewState();
}

class FlashcardViewState extends ConsumerState<FlashcardView>
    with SingleTickerProviderStateMixin, CommonWidgets {
  late PageController _pageController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentTabIndex);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Load more data when we're 80% of the way to the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (_currentTabIndex == 0) {
        ref.read(exploreFlashcardsProvider.notifier).loadMoreData();
      } else {
        ref.read(userFlashcardsProvider.notifier).loadMoreData();
      }
    }
  }

  void _updateSearch(String query) {
    if (_currentTabIndex == 0) {
      ref.read(exploreFlashcardsProvider.notifier).filterFlashcards(query);
    } else {
      ref.read(userFlashcardsProvider.notifier).filterFlashcards(query);
    }
  }

  void _createNewFlashcard() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CreateFlashcardView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Start off-screen at the bottom
          const end = Offset.zero; // End at its original position
          const curve = Curves.easeInOut; // Smooth easing curve

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration:
            const Duration(milliseconds: 300), // Animation duration
      ),
    );
  }

  void _changeTab(int index) {
    setState(() {
      _currentTabIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _searchController.clear();
      _updateSearch('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final exploreFlashcards = ref.watch(exploreFlashcardsProvider);
    final userFlashcards = ref.watch(userFlashcardsProvider);

    bool isLoading = exploreFlashcards.isLoading || userFlashcards.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(context.l10n!.flashcards),
        centerTitle: true,
      ),
      body: Skeletonizer(
        enabled: isLoading,
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // Tab buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _changeTab(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                width: 2,
                              ),
                              color: _currentTabIndex == 0
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                context.l10n!.exploration,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: _currentTabIndex == 0
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                width: 2,
                              ),
                              color: _currentTabIndex == 1
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                context.l10n!.yourFlashcards,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: _currentTabIndex == 1
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Gap(32),
                  // Create new flashcard button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: const Color(0xff2970FF),
                      fixedSize: Size(SizeConfig.w(356), SizeConfig.h(40)),
                    ),
                    onPressed: _createNewFlashcard,
                    child: Text(
                      context.l10n!.createNewFlashcard,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  const Gap(16),
                  // Search Container
                  FlashcardSearchContainer(
                    controller: _searchController,
                    onChanged: _updateSearch,
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentTabIndex = index;
                    _searchController.clear();
                    _updateSearch('');
                  });
                },
                children: [
                  // Explore Tab
                  _buildFlashcardsList(
                    exploreFlashcards,
                    context.l10n!.recentFlashcards,
                    false, // We'll check in the method
                    false, // We'll check in the method
                    onEmptyState: () => FlashcardEmptyState(
                      message: context.l10n!.emptyFlashcardMessage,
                    ),
                  ),

                  // User Flashcards Tab
                  _buildFlashcardsList(
                    userFlashcards,
                    context.l10n!.yourFlashcardsList,

                    false, // We'll check in the method
                    false, // We'll check in the method
                    onEmptyState: () => FlashcardEmptyState(
                      message: context.l10n!.emptyYourFlashcardMessage,
                      onCreateTap: _createNewFlashcard,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcardsList(
    AsyncValue<List<Flashcard>> flashcardsAsync,
    String headerText,
    bool hasMoreData,
    bool isLoadingMore, {
    required Widget Function() onEmptyState,
  }) {
    return flashcardsAsync.when(
      data: (flashcards) {
        if (flashcards.isEmpty) {
          return onEmptyState();
        }

        return SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlashcardHeader(text: headerText),
                const Gap(8),
                // Flashcard list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: flashcards.length,
                  itemBuilder: (context, index) {
                    return FlashcardItem(
                      flashcard: flashcards[index],
                      onTap: () {
                        Nav().push(FlashcardStudyView(
                            flashcardId: flashcards[index].sId!,
                            flashcardTitle: flashcards[index].title!));
                      },
                    );
                  },
                ),

                // Loading indicator
                if (_currentTabIndex == 0 &&
                    ref
                            .read(exploreFlashcardsProvider.notifier)
                            .isLoadingMore ==
                        true)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_currentTabIndex == 1 &&
                    ref.read(userFlashcardsProvider.notifier).isLoadingMore ==
                        true)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                // End of content message
                if ((_currentTabIndex == 0 &&
                        ref
                                .read(exploreFlashcardsProvider.notifier)
                                .hasMoreData ==
                            false &&
                        flashcards.isNotEmpty) ||
                    (_currentTabIndex == 1 &&
                        ref.read(userFlashcardsProvider.notifier).hasMoreData ==
                            false &&
                        flashcards.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        context.l10n!.endOfList,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoadingState(context, headerText),
      error: (error, stack) => Center(
        child: Text('Error: ${error.toString()}'),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, String headerText) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlashcardHeader(text: headerText),
            const Gap(16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return FlashcardItem(
                  flashcard: Flashcard(
                    title: context.l10n!.loading,
                    studentId: Student(name: 'Loading'),
                  ),
                  onTap: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
