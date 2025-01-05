// File: lib/core/theme/colors.dart
import 'package:flutter/material.dart';

/// Design system colors for the medical application
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF0055A4); // Professional medical blue
  static const Color primaryLight = Color(0xFF4682B4); // Lighter shade for highlights
  static const Color primaryDark = Color(0xFF003366); // Darker shade for emphasis
  
  // Secondary colors
  static const Color secondary = Color(0xFF00AF91); // Calming medical green
  static const Color secondaryLight = Color(0xFF40C4AA);
  static const Color secondaryDark = Color(0xFF008975);
  
  // Accent colors
  static const Color accent = Color(0xFFFF6B6B); // Used for warnings and important actions
  static const Color success = Color(0xFF4CAF50); // For success states
  static const Color warning = Color(0xFFFFA726); // For warning states
  static const Color error = Color(0xFFEF5350); // For error states
  
  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceMedium = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFFE0E0E0);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Border and divider colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);
  
  // Semantic colors for medical context
  static const Color urgent = Color(0xFFD32F2F); // For urgent cases/notifications
  static const Color stable = Color(0xFF43A047); // For stable patient status
  static const Color monitoring = Color(0xFFFBC02D); // For cases needing monitoring
  static const Color neutral = Color(0xFF90A4AE); // For neutral information
}
