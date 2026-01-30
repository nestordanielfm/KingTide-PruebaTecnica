import 'package:flutter/material.dart';

/// Futurama-inspired color palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFF6B35); // Futurama orange
  static const Color secondary = Color(0xFF00D9FF); // Cyan/turquoise
  static const Color tertiary = Color(0xFF7B2CBF); // Purple

  // Background Colors
  static const Color background = Color(0xFF0F0F1E); // Deep space blue
  static const Color surface = Color(0xFF1A1A2E); // Dark space blue
  static const Color surfaceVariant = Color(0xFF2D2D44); // Lighter surface

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.black;

  // Accent Colors
  static const Color accent = Color(0xFF00D9FF); // Cyan
  static const Color gold = Color(0xFFFFD700); // Gold for ratings
  static const Color error = Color(0xFFFF6B35); // Orange for errors

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);

  AppColors._();
}

/// App theme configuration
class AppTheme {
  static const String fontFamily = 'Futurama';
  static const String titleFontFamily = 'FuturamaTitle';

  static ThemeData get theme {
    return ThemeData(
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: titleFontFamily,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        labelStyle: const TextStyle(
          color: AppColors.accent,
          fontFamily: fontFamily,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: titleFontFamily),
        displayMedium: TextStyle(fontFamily: titleFontFamily),
        displaySmall: TextStyle(fontFamily: titleFontFamily),
        headlineLarge: TextStyle(fontFamily: titleFontFamily),
        headlineMedium: TextStyle(fontFamily: titleFontFamily),
        headlineSmall: TextStyle(fontFamily: titleFontFamily),
        titleLarge: TextStyle(fontFamily: titleFontFamily),
        titleMedium: TextStyle(fontFamily: titleFontFamily),
        titleSmall: TextStyle(fontFamily: titleFontFamily),
        bodyLarge: TextStyle(fontFamily: fontFamily),
        bodyMedium: TextStyle(fontFamily: fontFamily),
        bodySmall: TextStyle(fontFamily: fontFamily),
        labelLarge: TextStyle(fontFamily: titleFontFamily),
        labelMedium: TextStyle(fontFamily: fontFamily),
        labelSmall: TextStyle(fontFamily: fontFamily),
      ),
      useMaterial3: true,
    );
  }

  AppTheme._();
}
