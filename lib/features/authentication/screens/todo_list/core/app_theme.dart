import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // --- Colors ---
  static const Color primaryPurple = Color(0xFF673AB7);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color surfaceGray = Color(0xFFF5F5F5);
  static const Color borderSubtle = Color(0xFFE0E0E0);
  static const Color errorLight = Color(
    0xFFFFCDD2,
  ); // Light red for High priority
  static const Color warningOrange = Color(
    0xFFFF9800,
  ); // Orange for Medium priority
  static const Color successGreen = Color(0xFF4CAF50); // Green for Low priority
  static const Color infoBlue = Color(0xFF2196F3); // Blue for info messages
  static const Color shadowLight = Color(
    0x1A000000,
  ); // A light shadow color (alpha 0.1)

  // --- Light Theme ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: surfaceGray,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryPurple,
      foregroundColor: backgroundWhite,
      elevation: 0,
      centerTitle: false, // Adjust as per your preference
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryPurple,
      foregroundColor: backgroundWhite,
    ),
    // Define text themes
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      titleMedium: TextStyle(fontSize: 18, color: textPrimary),
      titleSmall: TextStyle(fontSize: 14, color: textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: textPrimary),
      labelSmall: TextStyle(fontSize: 12, color: textPrimary),
    ),
    // Define input decoration theme for TextFormFields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceGray,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), // Adjusted from .w/.h for standard
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorLight, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorLight, width: 2),
      ),
      hintStyle: const TextStyle(color: textSecondary),
    ),
    // Define button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ), // Adjusted from .h for standard
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryPurple,
        side: const BorderSide(color: primaryPurple),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ), // Adjusted from .h for standard
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryPurple),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryPurple,
      secondary:
          primaryPurple, // You can define a separate secondary color if needed
      error: errorLight,
      background: backgroundWhite,
      surface: surfaceGray,
    ),
  );

  // You can keep a placeholder for darkTheme or remove it if not needed at all.
  // For now, I'll remove it as you specified "only light".
  // static final ThemeData datkTheme = ThemeData(...);
}
