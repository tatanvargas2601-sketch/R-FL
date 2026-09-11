import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bgLight = Color(0xFFEFF7EE);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const borderLight = Color(0xFFD7E2D3);
  static const primary = Color(0xFF1F7D34);
  static const primaryDarkLight = Color(0xFF14532D);
  static const textLight = Color(0xFF132915);
  static const textMutedLight = Color(0xFF4D634E);

  static const bgDark = Color(0xFF102012);
  static const surfaceDark = Color(0xFF17271A);
  static const borderDark = Color(0x1FFFFFFF);
  static const primaryDarkMode = Color(0xFF8DBFA1);
  static const primaryDarkAccent = Color(0xFFDBE9D7);
  static const textDark = Color(0xFFF7F9F5);
  static const textMutedDark = Color(0xFFB9C3AF);

  static const loginLeftGradientLight = [Color(0xFFEFF7EE), Color(0xFFDFEADF)];
  static const loginLeftBgDark = Color(0xFF162418);
  static const welcomeTextDark = Color(0xFF66D17D);
}

class AppTheme {
  static TextTheme _textTheme(Color text, Color textMuted) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      headlineLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700, color: text, fontSize: 40),
      headlineMedium: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700, color: text, fontSize: 30),
      headlineSmall: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700, color: text, fontSize: 24),
      titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w700, color: text),
      titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: text),
      titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w600, color: text),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: text),
      bodyLarge: GoogleFonts.inter(color: text),
      bodyMedium: GoogleFonts.inter(color: textMuted),
      bodySmall: GoogleFonts.inter(color: textMuted),
    );
  }

  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bgLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primaryDarkLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textLight,
      outline: AppColors.borderLight,
    ),
    textTheme: _textTheme(AppColors.textLight, AppColors.textMutedLight),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textLight,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderLight),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.all(15),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF5FAF4),
      selectedColor: AppColors.primary,
      labelStyle: GoogleFonts.inter(color: AppColors.textLight),
      shape: const StadiumBorder(),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bgDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDarkMode,
      onPrimary: AppColors.textLight,
      secondary: AppColors.primaryDarkAccent,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textDark,
      outline: AppColors.borderDark,
    ),
    textTheme: _textTheme(AppColors.textDark, AppColors.textMutedDark),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderDark),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF243626),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF355339)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryDarkMode, width: 2),
      ),
      contentPadding: const EdgeInsets.all(15),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF2D8A43),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF203023),
      selectedColor: AppColors.primaryDarkMode,
      labelStyle: GoogleFonts.inter(color: AppColors.textDark),
      shape: const StadiumBorder(),
    ),
  );
}
