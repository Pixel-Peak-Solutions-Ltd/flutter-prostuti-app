import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/leaderboard/viewmodel/leaderboard_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../view/leaderboard_view.dart';
import 'leaderboard_card.dart';

class LeaderboardSection extends ConsumerWidget {
  const LeaderboardSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalLeaderboardAsyncValue = ref.watch(globalLeaderboardProvider);

    return Column(
      children: [
        // Header with title and "See more" button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "স্টুডেন্ট লিডারবোর্ড",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                Nav().push(const FullLeaderboardView());
              },
              child: Text(
                "আরো দেখুন",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        ),

        // Use the classic when pattern but with clear separation of states
        globalLeaderboardAsyncValue.when(
          data: (leaderboardData) {
            if (leaderboardData.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "No leaderboard data available",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // Get only top 3 for home screen
            final topThree = leaderboardData.take(3).toList();

            return Column(
              children: List.generate(
                topThree.length,
                (index) => TopLeaderboardItem(
                  student: topThree[index],
                  rank: index + 1,
                ),
              ),
            );
          },
          loading: () => _buildLoadingSkeleton(),
          error: (error, stack) {
            print('🔴 Leaderboard Section Error: $error, $stack');
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Error loading leaderboard data",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.red.shade700,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.refresh(globalLeaderboardProvider);
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: index == 0
                  ? const Color(0xFFFEE8DE)
                  : (index == 1
                      ? const Color(0xFFE2F6E9)
                      : const Color(0xFFFFF6DC)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 60,
                    height: 16,
                    color: Colors.grey,
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
