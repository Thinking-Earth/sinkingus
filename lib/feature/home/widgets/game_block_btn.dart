import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

InkWell gameBlockBtn({required String text, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 180.w,
      height: 48.h,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.gameBlockBtn),
          fit: BoxFit.fill
        )
      ),
      child: Text(
        text,
        style: AppTypography.labelCute,
      ),
    ),
  );
}