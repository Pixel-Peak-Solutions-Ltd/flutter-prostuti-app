// theme_provider.dart

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart'; // Generated code will be here

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    // Initialize with light theme
    return ThemeMode.light;
  }

  /// Toggles between light and dark themes
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  /// Sets the theme to light
  void setLightTheme() {
    state = ThemeMode.light;
  }

  /// Sets the theme to dark
  void setDarkTheme() {
    state = ThemeMode.dark;
  }
}
