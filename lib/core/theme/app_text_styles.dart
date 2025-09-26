import "package:flutter/material.dart";
import "package:emotiary/core/theme/app_colors.dart";

class AppTextStyles {
  static const TextStyle bodySmall = TextStyle(fontFamily: "Urbanist", fontSize: 12, color: AppColors.taupeGray, fontWeight: FontWeight.w500);
  static const TextStyle bodyMedium = TextStyle(fontFamily: "Urbanist", fontSize: 14, color: AppColors.taupeGray, fontWeight: FontWeight.w500);
  static const TextStyle bodyLarge = TextStyle(fontFamily: "Urbanist", fontSize: 16, color: AppColors.taupeGray, fontWeight: FontWeight.w500);

  static const TextStyle titleSmall = TextStyle(fontFamily: "Urbanist", fontSize: 16, color: AppColors.darkBrown, fontWeight: FontWeight.w700);
  static const TextStyle titleMedium = TextStyle(fontFamily: "Urbanist", fontSize: 20, color: AppColors.darkBrown, fontWeight: FontWeight.w700);
  static const TextStyle titleLarge = TextStyle(fontFamily: "Urbanist", fontSize: 24, color: AppColors.darkBrown, fontWeight: FontWeight.w700);

  static const TextStyle headlineSmall = TextStyle(fontFamily: "Urbanist", fontSize: 24, color: AppColors.darkBrown, fontWeight: FontWeight.w800);
  static const TextStyle headlineMedium = TextStyle(fontFamily: "Urbanist", fontSize: 28, color: AppColors.darkBrown, fontWeight: FontWeight.w800);
  static const TextStyle headlineLarge = TextStyle(fontFamily: "Urbanist", fontSize: 32, color: AppColors.darkBrown, fontWeight: FontWeight.w800);
}
