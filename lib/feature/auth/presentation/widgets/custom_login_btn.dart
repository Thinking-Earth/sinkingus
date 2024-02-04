import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget customLoginBtn({required VoidCallback onTap, required String svg, required String text, required TextStyle style, required Color backColor}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(4),
    child: Container(
      width: 183.w,
      height: 39.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: backColor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2.0,
            spreadRadius: 0.2
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            svg,
            width: 18.w,
          ),
          Text(text, style: style,)
        ],
      ),
    ),
  );
}