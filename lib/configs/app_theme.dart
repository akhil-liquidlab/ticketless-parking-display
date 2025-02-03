import 'package:flutter/material.dart';
import 'package:ticketless_parking_display/configs/app_colors.dart';

class AppTheme {
  static getLightTheme(context) {
    var textTheme = TextTheme.of(context)
        .apply(bodyColor: AppColors.darkText, displayColor: AppColors.darkText);
    return ThemeData(
        scaffoldBackgroundColor: AppColors.lightBG, textTheme: textTheme);
  }

  static getDarkTheme(context) {
    var textTheme = TextTheme.of(context).apply(
        bodyColor: AppColors.lightText, displayColor: AppColors.lightText);
    return ThemeData(
        scaffoldBackgroundColor: AppColors.darkBG, textTheme: textTheme);
  }

  static ThemeMode themeMode = ThemeMode.light;
}
