import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.textActionPrimaryLight,
    scaffoldBackgroundColor: AppColors.backgroundPrimaryLight,
    brightness: Brightness.light,
    textTheme: GoogleFonts.hindSiliguriTextTheme().copyWith(
      bodyLarge: const TextStyle(
          color: AppColors.textPrimaryLight), // Set for body text
      titleLarge: const TextStyle(
          color: AppColors.textSecondaryLight), // Set for headlines
      bodySmall: const TextStyle(
          color: AppColors.textTertiaryLight), // Set for captions
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundSecondaryLight,
      contentPadding: const EdgeInsets.all(30),
      hintStyle: const TextStyle(
        color: AppColors.textTertiaryLight,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide:
            const BorderSide(color: AppColors.borderNormalLight, width: 0.4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
            color: AppColors.borderFocusPrimaryLight, width: 0.4),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.textActionPrimaryDark,
    scaffoldBackgroundColor: AppColors.backgroundPrimaryDark,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.hindSiliguriTextTheme().copyWith(
      bodyLarge: const TextStyle(
          color: AppColors.textPrimaryDark), // Dark mode body text
      titleLarge: const TextStyle(
          color: AppColors.textSecondaryDark), // Dark mode headlines
      bodySmall: const TextStyle(
          color: AppColors.textTertiaryDark), // Dark mode captions
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundSecondaryDark,
      contentPadding: const EdgeInsets.all(30),
      hintStyle: const TextStyle(
        color: AppColors.textTertiaryDark,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide:
            const BorderSide(color: AppColors.borderNormalDark, width: 0.4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
            color: AppColors.borderFocusPrimaryDark, width: 0.4),
      ),
    ),
  );
}
