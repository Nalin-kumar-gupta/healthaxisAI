
// File: lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'dimensions.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        background: AppColors.background,
        error: AppColors.error,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.headline1,
        displayMedium: AppTextStyles.headline2,
        titleMedium: AppTextStyles.subtitle1,
        bodyLarge: AppTextStyles.body1,
        bodyMedium: AppTextStyles.body2,
        labelLarge: AppTextStyles.button,
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: AppDimensions.elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing24,
            vertical: AppDimensions.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),
    );
  }
}