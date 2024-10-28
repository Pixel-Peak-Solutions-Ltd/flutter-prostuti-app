import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  bool isLoading = false;

  Debouncer({required this.milliseconds});

  void run({
    required Future<void> Function() action,
    required StateController<bool> loadingController,
  }) {
    _timer?.cancel(); // Cancel any existing timer

    loadingController.state = true; // Set loading to true
    isLoading = true;

    _timer = Timer(Duration(milliseconds: milliseconds), () async {
      await action(); // Execute the debounced action

      loadingController.state =
          false; // Set loading to false after action completes
      isLoading = false;
    });
  }

  void cancel() {
    _timer?.cancel();
    isLoading = false;
  }
}
