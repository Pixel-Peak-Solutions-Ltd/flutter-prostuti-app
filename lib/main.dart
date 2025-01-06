import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:prostuti/features/home_screen/view/home_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/helpers/theme_provider.dart';
import 'core/configs/app_themes.dart';
import 'core/services/size_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isLoggedInAsync = ref.watch(isLoggedInProvider);

    return isLoggedInAsync.when(
      data: (isLoggedIn) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Prostuti',
          navigatorKey: Nav().navigatorKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: Builder(
            builder: (context) {
              SizeConfig.init(context);
              return isLoggedIn
                  ? HomeScreen()
                  : const LoginView(); // Navigate based on login state
            },
          ),
        );
      },
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stackTrace) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: Text('Error loading login state'))),
      ),
    );
  }
}

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final accessExpiryTime = prefs.getInt('accessExpiryTime');

  if (accessToken != null && accessExpiryTime != null) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return accessExpiryTime > now;
  }
  return false;
});
