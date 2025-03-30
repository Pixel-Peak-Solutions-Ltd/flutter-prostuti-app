import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../model/flashcard_model.dart';
import '../../viewmodel/flashcard_viewmodel.dart';
import '../../widgets/flashcard_empty_state.dart';
import '../../widgets/flashcard_header.dart';
import '../../widgets/flashcard_item.dart';

class ExploreTab extends ConsumerStatefulWidget {
  const ExploreTab({super.key});

  @override
  ExploreTabState createState() => ExploreTabState();
}

class ExploreTabState extends ConsumerState<ExploreTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // When we're 80% of the way to the bottom, load more data
      final flashcardNotifier = ref.read(exploreFlashcardsProvider.notifier);
      flashcardNotifier.loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(exploreFlashcardsProvider);

    return flashcardsAsync.when(
      data: (flashcards) {
        if (flashcards.isEmpty) {
          return const FlashcardEmptyState(
            message: 'এখানে কোন ফ্লাশকার্ড নেই',
          );
        }

        return _buildFlashcardList(context, flashcards);
      },
      loading: () => _buildLoadingState(context),
      error: (error, stack) => Center(
        child: Text('Error: ${error.toString()}'),
      ),
    );
  }

  Widget _buildFlashcardList(
    BuildContext context,
    List<Flashcard> flashcards,
  ) {
    final flashcardNotifier = ref.watch(exploreFlashcardsProvider.notifier);
    final isLoadingMore = flashcardNotifier.isLoadingMore;
    final hasMoreData = flashcardNotifier.hasMoreData;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const FlashcardHeader(text: 'সাম্প্রতিক ফ্লাশকার্ড'),
              const Gap(16),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FlashcardItem(
                  flashcard: flashcards[index],
                  onTap: () {
                    // Navigate to flashcard details
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Open flashcard: ${flashcards[index].title}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
              childCount: flashcards.length,
            ),
          ),
        ),

        // Loading indicator at the bottom
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),

        // End of content message
        if (!hasMoreData && flashcards.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'আপনি সব ফ্লাশকার্ড দেখেছেন',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const FlashcardHeader(text: 'সাম্প্রতিক ফ্লাশকার্ড'),
              const Gap(16),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FlashcardItem(
                  flashcard: Flashcard(
                    title: 'Loading Flashcard',
                    studentId: Student(name: 'Loading'),
                  ),
                  onTap: () {},
                );
              },
              childCount: 3,
            ),
          ),
        ),
      ],
    );
  }
}
