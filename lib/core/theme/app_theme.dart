import 'package:flutter/material.dart';

class AppTheme {
  // SOMOS brand colors
  static const Color primaryBlue = Color(0xFF0066CC);
  static const Color secondaryBlue = Color(0xFF3399FF);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF8F9FA);
  static const Color textColor = Color(0xFF2D3748);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      background: backgroundColor,
      surface: surfaceColor,
      onSurface: textColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!),
      ),
    ),
  );
} 