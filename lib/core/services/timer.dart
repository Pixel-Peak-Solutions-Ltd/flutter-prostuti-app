import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountdownState {
  final Duration remainingTime;
  final bool isRunning;

  CountdownState({required this.remainingTime, required this.isRunning});
}

class CountdownNotifier extends StateNotifier<CountdownState> {
  Timer? _timer;

  CountdownNotifier()
      : super(CountdownState(remainingTime: Duration.zero, isRunning: false));

  void initialize(Duration duration) {
    state = CountdownState(remainingTime: duration, isRunning: false);
  }

  void startTimer() {
    if (state.remainingTime.inSeconds > 0) {
      _timer?.cancel();
      state =
          CountdownState(remainingTime: state.remainingTime, isRunning: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (state.remainingTime.inSeconds > 0) {
          state = CountdownState(
            remainingTime: state.remainingTime - const Duration(seconds: 1),
            isRunning: true,
          );
        } else {
          _timer?.cancel();
          state =
              CountdownState(remainingTime: Duration.zero, isRunning: false);
        }
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    state =
        CountdownState(remainingTime: state.remainingTime, isRunning: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final countdownProvider =
    StateNotifierProvider<CountdownNotifier, CountdownState>(
        (ref) => CountdownNotifier());
