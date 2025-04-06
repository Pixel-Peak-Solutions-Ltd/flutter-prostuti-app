import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';

// Language model
class Language {
  final String code;
  final String name;
  final String localName;

  Language(this.code, this.name, this.localName);
}

// Available languages
final languages = [
  Language('en', 'English', 'English'),
  Language('bn', 'Bangla', 'বাংলা'),
];

// Provider for language state
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

// Notifier to handle language changes
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('bn')) {
    _loadSavedLanguage();
  }

  // Load the saved language from preferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code');
    if (savedLanguage != null) {
      state = Locale(savedLanguage);
    }
  }

  // Change the app language
  Future<void> changeLanguage(String languageCode) async {
    state = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }
}

// Extension method for easy access to localized strings
extension LocalizationExtension on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
}
