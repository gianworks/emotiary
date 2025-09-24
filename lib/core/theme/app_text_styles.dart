import "package:flutter/material.dart";
import "package:emotiary/core/theme/app_colors.dart";

class AppTextStyles {
  static const TextStyle bodySmall = TextStyle(fontSize: 12, color: AppColors.taupeGray, fontWeight: FontWeight.w500);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, color: AppColors.taupeGray, fontWeight: FontWeight.w500);
  static const TextStyle bodyLarge = TextStyle(fontSize: 16, color: AppColors.taupeGray, fontWeight: FontWeight.w500);

  static const TextStyle titleSmall = TextStyle(fontSize: 16, color: AppColors.darkBrown, fontWeight: FontWeight.w700);
  static const TextStyle titleMedium = TextStyle(fontSize: 20, color: AppColors.darkBrown, fontWeight: FontWeight.w700);
  static const TextStyle titleLarge = TextStyle(fontSize: 24, color: AppColors.darkBrown, fontWeight: FontWeight.w700);

  static const TextStyle headlineSmall = TextStyle(fontSize: 24, color: AppColors.darkBrown, fontWeight: FontWeight.w800);
  static const TextStyle headlineMedium = TextStyle(fontSize: 28, color: AppColors.darkBrown, fontWeight: FontWeight.w800);
  static const TextStyle headlineLarge = TextStyle(fontSize: 32, color: AppColors.darkBrown, fontWeight: FontWeight.w800);
}
