import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get blackPixel => TextStyle(
      fontFamily: 'Galmuri', fontSize: 10.sp, color: AppColors.textBlack);
  static TextStyle get whitePixel => TextStyle(
      fontFamily: 'Galmuri', fontSize: 10.sp, color: AppColors.textWhite);
  static TextStyle get grayPixel => TextStyle(
      fontFamily: 'Galmuri',
      fontSize: 10.sp,
      color: const Color.fromARGB(255, 166, 166, 166));
  static TextStyle get timerPixel => TextStyle(
      fontFamily: 'Galmuri',
      fontSize: 20.sp,
      color: AppColors.textBlack,
      fontWeight: FontWeight.w900);
}
