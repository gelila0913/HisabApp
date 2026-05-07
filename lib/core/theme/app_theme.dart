import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF8A00);
  static const background = Color(0xFFF5F5F5);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF777777);
  static const cardBorder = Color(0xFFE0E0E0);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto',
  );
}