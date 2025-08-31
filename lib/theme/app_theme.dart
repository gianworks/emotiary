import "package:flutter/material.dart";
import "package:emotiary/theme/app_colors.dart";

class AppTheme {
  static ThemeData appThemeData = ThemeData(
    fontFamily: "Inter",
    scaffoldBackgroundColor: AppColors.beige,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.sienna,
      foregroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 70,
      titleTextStyle: TextStyle(
        fontFamily: "Inter", 
        fontSize: 24,
        fontWeight: FontWeight.w700, 
        color: AppColors.veryDarkBrown
      ),
      shape: Border(bottom: BorderSide(color: AppColors.tan)),
      backgroundColor: AppColors.beige
    )
  );
}
