import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppColorScheme {
  static ColorScheme lightScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.backgroundPrimaryLight,
    onPrimary: AppColors.textActionPrimaryLight,
    secondary: AppColors.backgroundActionSecondaryLight,
    onSecondary: AppColors.textActionSecondaryLight,
    surface: AppColors.backgroundTertiaryLight,
    onSurface: AppColors.textPrimaryLight,
    background: AppColors.backgroundPrimaryLight,
    onBackground: AppColors.textSecondaryLight,
    error: Colors.red,
    onError: Colors.white,
    primaryContainer: AppColors.shadePrimaryLight,
    secondaryContainer: AppColors.shadeSecondaryLight,
    onPrimaryContainer: AppColors.textPrimaryLight,
    onSecondaryContainer: AppColors.textSecondaryLight,
    outline: AppColors.scaffoldBackgroundLight,
  );

  static ColorScheme darkScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.backgroundPrimaryDark,
    onPrimary: AppColors.textActionPrimaryDark,
    secondary: AppColors.backgroundActionSecondaryDark,
    onSecondary: AppColors.textActionSecondaryDark,
    surface: AppColors.backgroundTertiaryDark,
    onSurface: AppColors.textPrimaryDark,
    background: AppColors.backgroundPrimaryDark,
    onBackground: AppColors.textSecondaryDark,
    error: Colors.redAccent,
    onError: Colors.black,
    primaryContainer: AppColors.shadePrimaryDark,
    secondaryContainer: AppColors.shadeSecondaryDark,
    onPrimaryContainer: AppColors.textPrimaryDark,
    onSecondaryContainer: AppColors.textSecondaryDark,
    outline: AppColors.scaffoldBackgroundDark,
  );
}

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: AppColorScheme.lightScheme,
    primaryColor: AppColors.textActionPrimaryLight,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundLight,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.shadeSecondaryLight,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: GoogleFonts.hindSiliguriTextTheme().copyWith(
      titleLarge: const TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: const TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: const TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: const TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: const TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.backgroundSecondaryLight,
      // contentPadding: const EdgeInsets.all(30),
      hintStyle: const TextStyle(
        color: AppColors.textTertiaryLight,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: AppColors.borderNormalLight, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
            color: AppColors.borderFocusPrimaryLight, width: 1),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: AppColorScheme.darkScheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.shadeSecondaryDark,
      foregroundColor: AppColors.textPrimaryDark,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    primaryColor: AppColors.textActionPrimaryDark,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.hindSiliguriTextTheme().copyWith(
      titleLarge: const TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: const TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: const TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: const TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xff2B415B),
      hintStyle: const TextStyle(
        color: AppColors.textTertiaryDark,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
    ),
  );
}
