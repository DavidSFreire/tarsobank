import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF3629B7);
  static const Color primaryLight = Color(0xFF0066CC);
  static const Color accentGreen = Color(0xFF00CC88);
  static const Color accentOrange = Color(0xFFFF6600);
  static const Color background = Color(0xFFF2F4F7);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textDisabled = Color(0xFFAAAAAA);
  static const Color dividerColor = Color(0xFFE0E0E0);

  static LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient accentGradient = LinearGradient(
    colors: [accentGreen, accentOrange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static TextStyle headlineLarge = const TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w800,
    color: textPrimary,
  );

  static TextStyle headlineMedium = const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static TextStyle headlineSmall = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle loginTitle = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: primaryDark,
    letterSpacing: -0.5,
  );

  static TextStyle bodyLarge = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static TextStyle bodySmall = const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static TextStyle buttonText = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: primaryDark,
      secondary: accentGreen,
      surface: cardColor,
      error: Colors.red,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headlineMedium.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: cardColor,
      shadowColor: Colors.black.withOpacity(0.05),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        textStyle: bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      prefixIconColor: primaryDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      labelStyle: bodyMedium.copyWith(color: textSecondary),
      hintStyle: bodyMedium.copyWith(color: textDisabled),
    ),
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),
    textTheme: TextTheme(
      displayLarge: headlineLarge,
      displayMedium: headlineMedium,
      displaySmall: headlineSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: buttonText,
      titleLarge: loginTitle,
    ),
  );

  static TextStyle amountStyle(BuildContext context, {bool positive = true}) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: positive ? accentGreen : Colors.red,
    );
  }

  static List<BoxShadow> get cardShadows => [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
}