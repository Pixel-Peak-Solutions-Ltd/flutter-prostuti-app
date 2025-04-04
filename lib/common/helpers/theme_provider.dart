import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

const _themeModeKey = 'theme_mode';

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    // Start with system theme and then load the saved theme
    _loadThemeMode();
    return ThemeMode.system; // Default to system theme initially
  }

  // Check if user has explicitly set a theme preference
  bool get hasExplicitThemeChoice => state != ThemeMode.system;

  // Check if the current theme is dark
  bool isDarkTheme(BuildContext context) {
    if (state == ThemeMode.system) {
      // Use the system setting if ThemeMode is system
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    // Otherwise use the explicitly set theme
    return state == ThemeMode.dark;
  }

  // Load the theme mode from SharedPreferences asynchronously
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeModeKey);

    ThemeMode themeMode;
    switch (savedTheme) {
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'light':
        themeMode = ThemeMode.light;
        break;
      default:
        themeMode = ThemeMode.system; // Default to system if no saved theme
    }

    // Update the state after loading the saved theme
    state = themeMode;
  }

  /// Toggles between light and dark themes and saves the choice
  void toggleTheme(BuildContext context) async {
    ThemeMode newTheme;

    if (state == ThemeMode.system) {
      // If currently using system theme, switch to explicit light/dark based on current system setting
      newTheme = MediaQuery.platformBrightnessOf(context) == Brightness.dark
          ? ThemeMode.light // If system is dark, switch to light
          : ThemeMode.dark; // If system is light, switch to dark
    } else {
      // If already using explicit setting, just toggle between light and dark
      newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }

    await _saveThemeMode(newTheme);
    state = newTheme;
  }

  /// Sets the theme to light and saves it
  void setLightTheme() async {
    await _saveThemeMode(ThemeMode.light);
    state = ThemeMode.light;
  }

  /// Sets the theme to dark and saves it
  void setDarkTheme() async {
    await _saveThemeMode(ThemeMode.dark);
    state = ThemeMode.dark;
  }

  /// Reset to system theme
  void useSystemTheme() async {
    await _saveThemeMode(ThemeMode.system);
    state = ThemeMode.system;
  }

  /// Save the theme mode to SharedPreferences
  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _themeModeKey,
        themeMode == ThemeMode.dark
            ? 'dark'
            : themeMode == ThemeMode.light
                ? 'light'
                : 'system');
  }
}
