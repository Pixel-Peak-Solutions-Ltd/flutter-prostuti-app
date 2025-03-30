import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlashcardEmptyState extends StatelessWidget {
  final String message;
  final VoidCallback? onCreateTap;

  const FlashcardEmptyState({
    super.key,
    required this.message,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_flashcard.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          const Gap(24),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (onCreateTap != null) ...[
            const Gap(24),
            ElevatedButton(
              onPressed: onCreateTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ফ্লাশকার্ড তৈরি করুন',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor)),
            ),
          ],
        ],
      ),
    );
  }
}
