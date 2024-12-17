import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';

import 'common/helpers/theme_provider.dart';
import 'common/view_model/auth_notifier.dart';
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
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prostuti',
      navigatorKey: Nav().navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: Builder(builder: (context) {
        SizeConfig.init(context);
        return LoginView();
      }),
    );
  }
}
