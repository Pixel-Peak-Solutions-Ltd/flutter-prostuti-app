import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_service.dart';

part 'no_internet_view.g.dart';

@riverpod
class ConnectivityStatus extends _$ConnectivityStatus {
  @override
  Stream<ConnectivityResult> build() {
    return ref.watch(connectivityProvider).onConnectivityChanged;
  }
}

class NoInternetView extends ConsumerStatefulWidget {
  const NoInternetView({Key? key}) : super(key: key);

  @override
  ConsumerState<NoInternetView> createState() => _NoInternetViewState();
}

class _NoInternetViewState extends ConsumerState<NoInternetView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Setup animation for the icon and retry button
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Check connectivity on page load
    _checkConnectivity();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Check if the internet is back
  Future<void> _checkConnectivity() async {
    final isConnected = await ref.read(networkInfoProvider).isConnected;
    if (isConnected) {
      if (mounted) {
        Nav().pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for connectivity changes
    ref.listen<AsyncValue<ConnectivityResult>>(connectivityStatusProvider,
        (_, state) {
      state.whenData((result) {
        if (result != ConnectivityResult.none) {
          Navigator.of(context).pop();
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated WiFi Icon
                AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: Icon(
                          Icons.wifi_off_rounded,
                          size: 120,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      );
                    }),

                const SizedBox(height: 40),

                // Title
                Text(
                  'No Internet Connection',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  'Please check your internet connection and try again.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Retry Button
                ElevatedButton.icon(
                  onPressed: _checkConnectivity,
                  icon: Icon(Icons.refresh,
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                  label: Text(
                    'Retry',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
