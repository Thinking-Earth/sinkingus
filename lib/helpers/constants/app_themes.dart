import 'package:flutter/material.dart';

// Helpers
import 'app_colors.dart';

/// A utility class that holds themes for the app. It controls
/// how the app looks on different platforms like android, ios etc.
///
/// This class has no constructor and all methods are `static`.
@immutable
class AppThemes {
  const AppThemes._();

  static final mainTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primaryColor,
      background: AppColors.backgroundColor,
      error: AppColors.redColor,
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
  );
}
