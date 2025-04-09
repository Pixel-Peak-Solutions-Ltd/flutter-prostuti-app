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
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prostuti',
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
