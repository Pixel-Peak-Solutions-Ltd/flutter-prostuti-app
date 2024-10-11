import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    const decoration = InputDecoration();

    final decorationWithThemeProperties =
        decoration.applyDefaults(const InputDecorationTheme(
      filled: true,
      fillColor: Colors.red,
    ));
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Scaffold(),
    );
  }
}
