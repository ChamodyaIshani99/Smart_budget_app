import 'package:flutter/material.dart';

class AppTheme {
  static const Color seed = Color(0xFF1E88E5);

  // Used only for characters the normal font lacks (i.e. Sinhala).
  static const List<String> _fontFallback = ['NotoSansSinhala'];

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
    fontFamilyFallback: _fontFallback,
    appBarTheme: const AppBarTheme(centerTitle: true),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    ),
    fontFamilyFallback: _fontFallback,
  );
}