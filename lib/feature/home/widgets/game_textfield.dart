import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

Widget gameTextField(
    {required TextEditingController controller,
    required String hintText,
    VoidCallback? onSubmitted}) {
  return Container(
    height: 42.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AppImages.gameListTile), fit: BoxFit.fill)),
    child: TextField(
        controller: controller,
        onSubmitted: (_) {
          if (onSubmitted != null) {
            onSubmitted();
          }
        },
        style: AppTypography.blackPixel.copyWith(fontSize: 14.sp),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelStyle: AppTypography.blackPixel.copyWith(fontSize: 14.sp),
          labelText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        )),
  );
}
