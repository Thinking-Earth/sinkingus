import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';

@immutable
class AppTypography {
  const AppTypography._();
  
  static final blackPixel = TextStyle(
      fontFamily: 'Galmuri', fontSize: 10.sp, color: AppColors.textBlack);
  static final whitePixel = TextStyle(
      fontFamily: 'Galmuri', fontSize: 10.sp, color: AppColors.textWhite);
  static final grayPixel = TextStyle(
      fontFamily: 'Galmuri',
      fontSize: 10.sp,
      color: const Color.fromARGB(255, 166, 166, 166));
  static final timerPixel = TextStyle(
      fontFamily: 'Galmuri',
      fontSize: 20.sp,
      color: AppColors.textBlack,
      fontWeight: FontWeight.w900);
}
