import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;

  const CountdownTimer({Key? key, required this.duration}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remainingTime;
  late Timer timer;
  late double progress;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    progress = 1.0;
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
          progress = remainingTime.inSeconds / widget.duration.inSeconds;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Remaining Text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "সময় বাকী ",
              style: theme.textTheme.titleSmall,
            ),
            Text(
              _formatTime(remainingTime),
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        const Gap(8),
        // Progress Bar
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 8,
        ),
      ],
    );
  }
}
