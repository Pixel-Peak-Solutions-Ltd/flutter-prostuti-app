import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/services/timer.dart';

final _previousTimerStateProvider = StateProvider<bool>((ref) => false);

class CountdownTimer extends ConsumerStatefulWidget {
  final VoidCallback onTimeUp;

  const CountdownTimer({super.key, required this.onTimeUp});

  @override
  ConsumerState<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends ConsumerState<CountdownTimer> {
  Duration? _maxTime;
  bool _hasStarted = false;

  @override
  Widget build(BuildContext context) {
    final countdownState = ref.watch(countdownProvider);

    if (countdownState.remainingTime.inSeconds > 0 && _maxTime == null) {
      _maxTime = countdownState.remainingTime;
    }

    if (countdownState.isRunning && !_hasStarted) {
      _hasStarted = true;
    }

    if (_hasStarted &&
        !countdownState.isRunning &&
        countdownState.remainingTime.inSeconds == 0) {
      _hasStarted = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTimeUp();
      });
    }

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
              "সময় বাকী ",
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
          value: countdownState.remainingTime.inSeconds > 0 && _maxTime != null
              ? countdownState.remainingTime.inSeconds / _maxTime!.inSeconds
              : 0,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 8,
        ),
      ],
    );
  }
}
