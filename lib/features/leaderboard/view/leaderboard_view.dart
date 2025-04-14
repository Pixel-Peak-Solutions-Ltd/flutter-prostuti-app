import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/leaderboard/viewmodel/leaderboard_viewmodel.dart';
import 'package:prostuti/features/profile/viewmodel/profile_viewmodel.dart';

import '../widgets/leaderboard_card.dart';

class FullLeaderboardView extends ConsumerStatefulWidget {
  const FullLeaderboardView({Key? key}) : super(key: key);

  @override
  _FullLeaderboardViewState createState() => _FullLeaderboardViewState();
}

class _FullLeaderboardViewState extends ConsumerState<FullLeaderboardView>
    with CommonWidgets {
  final _scrollController = ScrollController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final leaderboardNotifier = ref.read(globalLeaderboardProvider.notifier);
      if (!leaderboardNotifier.isLoadingMore && leaderboardNotifier.hasMore) {
        leaderboardNotifier.loadMoreData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalLeaderboardAsyncValue = ref.watch(globalLeaderboardProvider);
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    // Get current user ID
    if (userProfileAsyncValue.hasValue &&
        userProfileAsyncValue.value?.data != null) {
      _currentUserId = userProfileAsyncValue.value?.data?.studentId;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: commonAppbar("লিডারবোর্ড"),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(globalLeaderboardProvider.notifier).refreshLeaderboard();
        },
        child: globalLeaderboardAsyncValue.when(
          data: (leaderboardData) {
            if (leaderboardData.isEmpty) {
              return _buildEmptyState(context);
            }

            final topThree = leaderboardData.take(3).toList();
            final remaining =
                leaderboardData.length > 3 ? leaderboardData.sublist(3) : [];

            // Find current user's position if they're not in top 3
            int? currentUserPosition;
            if (_currentUserId != null) {
              for (int i = 0; i < leaderboardData.length; i++) {
                if (leaderboardData[i].studentId?.sId == _currentUserId) {
                  currentUserPosition = i + 1;
                  break;
                }
              }
            }

            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top 3 performers section
                  Text(
                    "টপ ৩ পারফর্মারস",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  for (int i = 0; i < topThree.length; i++)
                    TopLeaderboardItem(
                      student: topThree[i],
                      rank: i + 1,
                    ),

                  // Rest of the performers
                  if (remaining.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      "বাকি পারফর্মারস",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    for (int i = 0; i < remaining.length; i++)
                      RegularLeaderboardItem(
                        student: remaining[i],
                        rank: i + 4, // Start from rank 4
                        isCurrentUser:
                            remaining[i].studentId?.sId == _currentUserId,
                      ),

                    // Loading indicator at the bottom
                    if (ref.read(globalLeaderboardProvider.notifier).hasMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],

                  // Show current user position if not visible in current view
                  if (currentUserPosition != null &&
                      currentUserPosition > 10) ...[
                    const SizedBox(height: 24),
                    Text(
                      "তোমার অবস্থান ${currentUserPosition.toString().padLeft(2, '0')}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    RegularLeaderboardItem(
                      student: leaderboardData[currentUserPosition - 1],
                      rank: currentUserPosition,
                      isCurrentUser: true,
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(context, error),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No leaderboard data",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${error.toString()}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(globalLeaderboardProvider.notifier)
                    .refreshLeaderboard();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
