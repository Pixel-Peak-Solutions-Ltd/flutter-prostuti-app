import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course_list/view/course_list_view.dart';
import 'package:prostuti/features/home_screen/view/home_screen_view.dart';
import 'package:prostuti/features/login/view/login_view.dart';
import 'package:prostuti/features/onboarding/view/onboarding_view.dart';
import 'package:prostuti/features/signup/view/phone_view.dart';

import 'common/helpers/theme_provider.dart';
import 'common/view_model/auth_notifier.dart';
import 'core/configs/app_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prostuti',
      navigatorKey: Nav().navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: HomeScreen(),
    );
  }
}
