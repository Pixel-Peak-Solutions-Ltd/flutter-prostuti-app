import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:prostuti/features/home_screen/view/home_screen_view.dart';

import 'common/helpers/theme_provider.dart';
import 'common/view_model/auth_notifier.dart';
import 'core/configs/app_themes.dart';
import 'core/services/localization_service.dart';
import 'core/services/size_config.dart';
import 'features/splash_screen.dart';
import 'flutter_config.dart';
import 'l10n/app_localizations.dart';

// New method for the entry point from flavor-specific main files
void runMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

// Keep the original entry point for backward compatibility
void main() {
  // Default to development if running without specific flavor
  FlavorConfig(
    flavor: Flavor.development,
    name: "Development",
    baseUrl: "https://resilient-heart-dev.up.railway.app/api/v1",
    socketBaseUrl: 'https://resilient-heart-dev.up.railway.app',
  );

  runMain();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: kDebugMode ? true : false,
      title: 'Prostuti - ${FlavorConfig.instance.name}',
      // Add flavor name to title
      navigatorKey: Nav().navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
      home: const SplashScreen(),
    );
  }
}

class MainAppContent extends ConsumerWidget {
  const MainAppContent({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authNotifier = ref.watch(authNotifierProvider);

    SizeConfig.init(context);

    return authNotifier.when(
      data: (token) {
        if (token != null) {
          return const HomeScreen(); // User is logged in
        } else {
          return const LoginView(); // Redirect to login
        }
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => const LoginView(), // Redirect to login on error
    );
  }
}
