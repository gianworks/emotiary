import "package:flutter/material.dart";
import "package:emotiary/core/theme/app_colors.dart";

class AppTheme {
  static ThemeData themeData = ThemeData(
    fontFamily: "Urbanist",
    scaffoldBackgroundColor: AppColors.linenWhite,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      highlightElevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: AppColors.brownSugar
    )
  );
}
