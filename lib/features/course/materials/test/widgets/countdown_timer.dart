import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/services/timer.dart';

class CountdownTimer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countdownState = ref.watch(countdownProvider);

    String formatTime(Duration duration) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return "$hours:$minutes:$seconds";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "সময় বাকী ",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              formatTime(countdownState.remainingTime),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        const Gap(8),
        LinearProgressIndicator(
          value: countdownState.remainingTime.inSeconds > 0
              ? countdownState.remainingTime.inSeconds /
                  ref
                      .read(countdownProvider.notifier)
                      .state
                      .remainingTime
                      .inSeconds
              : 0,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 8,
        ),
      ],
    );
  }
}
