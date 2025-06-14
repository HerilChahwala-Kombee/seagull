import 'package:flutter/material.dart';
import '../constants/color_constant.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: ColorConstant.primary,
      scaffoldBackgroundColor: ColorConstant.background,
      colorScheme: const ColorScheme.light().copyWith(
        primary: ColorConstant.primary,
        secondary: ColorConstant.secondary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ColorConstant.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ColorConstant.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: ColorConstant.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: ColorConstant.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.buttonPrimary,
          foregroundColor: ColorConstant.textLight,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorConstant.buttonPrimary,
          side: const BorderSide(color: ColorConstant.buttonPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}