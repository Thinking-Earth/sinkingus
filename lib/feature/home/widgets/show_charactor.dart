import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';

InkWell showCharactor({
  required VoidCallback onTap,
  required String imageAsset
}) {
  return InkWell(
    onTap: (){},
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 40),
      width: 100.w,
      height: 130.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.fill
        )
      ),
    ),
  );
}