import 'package:flutter/material.dart';

class AppTheme {
  static const Color cyanNeon = Color(0xFF00F0FF);
  static const Color purpleNeon = Color(0xFFBC00FF);
  static const Color pinkNeon = Color(0xFFFF0055);
  static const Color backgroundBlack = Color(0xFF020408);
  static const Color surfaceDark = Color(0xFF0D1117);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      colorScheme: const ColorScheme.dark(
        primary: cyanNeon,
        secondary: purpleNeon,
        tertiary: pinkNeon,
        surface: surfaceDark,
        onSurface: Colors.white,
      ),
      fontFamily: 'Inter',
    );
  }
}
