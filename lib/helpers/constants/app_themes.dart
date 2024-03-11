import 'package:flutter/material.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';

@immutable
class AppTheme {
  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.green10, 
      selectionColor: AppColors.green10,
      selectionHandleColor: AppColors.green10,
    ),
    scaffoldBackgroundColor: Colors.white,
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(color: AppColors.textBlack)
    ),
  );
}