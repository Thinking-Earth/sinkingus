import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

InkWell downloadLink({
  required String img,
  required VoidCallback onTap
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 128.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle
      ),
      child: Image.asset(
        img
      ),
    ),
  );
}