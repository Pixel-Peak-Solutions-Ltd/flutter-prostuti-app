import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/configs/app_colors.dart';

import '../model/flashcard_model.dart';
import '../viewmodel/flashcard_item_count_provider.dart';

class FlashcardItem extends ConsumerWidget {
  final Flashcard flashcard;
  final VoidCallback onTap;

  const FlashcardItem({
    super.key,
    required this.flashcard,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, ref) {
    final countAsync =
        ref.watch(flashcardItemCountProvider(flashcard.sId ?? ''));

    // Use a simple method to display the item count
    final itemCountText = countAsync.when(
      data: (count) => '$count items',
      loading: () => 'Loading items', // Just show dots while loading
      error: (_, __) => 'null items',
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.textActionTertiaryDark,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 18,
                    ),
                    const Gap(8),
                    Text(
                      'Today 172 times studied',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.textActionPrimaryDark),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Text(
                flashcard.title ?? 'Untitled Flashcard',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(8),
              Text(
                itemCountText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Gap(12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey.shade200,
                    child: const Text(
                      'A',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    flashcard.studentId?.name ?? 'Unknown',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
