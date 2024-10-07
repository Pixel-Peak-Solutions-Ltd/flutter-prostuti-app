import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/helpers/theme_provider.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () =>
                  ref.read(themeNotifierProvider.notifier).setLightTheme(),
              child: Text('light'),
            ),
            Text(
              'Hello, themed world!',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge, // Uses the theme's text style
            ),
            ElevatedButton(
              onPressed: () =>
                  ref.read(themeNotifierProvider.notifier).setDarkTheme(),
              child: Text('dark'),
            ),
          ],
        ),
      ),
    );
  }
}
