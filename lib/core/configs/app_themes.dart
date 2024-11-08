import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/*
24px: titleLarge
20px: titleMedium
18px: titleSmall
16px: bodyLarge
14px: bodyMedium
12px: bodySmall
 */

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.textActionPrimaryLight,
    scaffoldBackgroundColor: AppColors.backgroundPrimaryLight,
    brightness: Brightness.light,
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
    primaryColor: AppColors.textActionPrimaryDark,
    scaffoldBackgroundColor: AppColors.backgroundPrimaryDark,
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
      fillColor: AppColors.backgroundSecondaryDark,
      hintStyle: const TextStyle(
        color: AppColors.textTertiaryDark,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: AppColors.borderNormalDark, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: AppColors.borderFocusPrimaryDark, width: 1),
      ),
    ),
  );
}
