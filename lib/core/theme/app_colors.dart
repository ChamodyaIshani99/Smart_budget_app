import 'package:flutter/material.dart';

class AppColors {
  static const Color indigo = Color(0xFF4F46E5);
  static const Color violet = Color(0xFF7C3AED);
  static const Color background = Color(0xFFF5F6FA);
  static const Color darkBackground = Color(0xFF0E1015);
  static const Color darkSurface = Color(0xFF181B22);
  static const Color danger = Color(0xFFDC2626);

  static LinearGradient heroGradient(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: dark
          ? const [Color(0xFF3730A3), Color(0xFF6D28D9)]
          : const [indigo, violet],
    );
  }

  static final List<BoxShadow> heroShadow = [
    BoxShadow(
      color: indigo.withValues(alpha: 0.30),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}