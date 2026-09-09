import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color background = Color(0xFF0C0C0E);
  static const Color surface = Color(0xFF18181B);
  static const Color surfaceElevated = Color(0xFF27272A);
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF52525B);

  static const Color startAccent = Color(0xFF22C55E);
  static const Color startBackground = Color(0xFF143823);
  static const Color pauseAccent = Color(0xFFF97316);
  static const Color pauseBackground = Color(0xFF382214);
  static const Color resetAccent = Color(0xFFE4E4E7);
  static const Color resetBackground = Color(0xFF27272A);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: startAccent,
        onSurface: textPrimary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 72,
          fontWeight: FontWeight.w200,
          letterSpacing: -1.5,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        displayMedium: TextStyle(
          color: textSecondary,
          fontSize: 40,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
