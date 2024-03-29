import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';

@immutable
class AppTypography {
  const AppTypography._();

  /// 22.sp
  /// FontWeight.w700
  static final title = TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  /// 20.sp
  /// FontWeight.w700
  static final header1 = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.textBlack);

  /// 16.sp
  /// FontWeight.w700
  static final body1 = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.textBlack);

  /// 14.sp
  /// FontWeight.w700
  static final body2 = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.textBlack);

  /// 12.sp
  /// FontWeight.w700
  static final alertGrey = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.black40);

  /// 12.sp
  /// FontWeight.w700
  static final label1 = TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  ////////////////////////////////////////Jalnan/////////////////////////////////////////////

  /// 22.sp
  /// FontWeight.w400
  static final titleCute = TextStyle(
    fontFamily: 'Jalnan',
    fontSize: 22.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
  );

  /// 20.sp
  /// FontWeight.w400
  static final headerCute = TextStyle(
    fontFamily: 'Jalnan',
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
  );

  /// 16.sp
  /// FontWeight.w400
  static final bodyCute = TextStyle(
    fontFamily: 'Jalnan',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
  );

  /// 12.sp
  /// FontWeight.w400
  static final labelCute = TextStyle(
    fontFamily: 'Jalnan',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
  );

  ///////////////////////////////////////////////////////////////////////////////////////////
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
