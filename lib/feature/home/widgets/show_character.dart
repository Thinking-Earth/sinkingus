import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

GestureDetector showCharacter({
  required VoidCallback onTap,
  required String imageAsset,
  required bool move,
  bool flip = false
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.deferToChild,
    child: Transform.flip(
      flipX: flip,
      child: Container(
        height: 130.h,
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 100.w,
          height: move ? 128.h : 130.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageAsset),
              fit: BoxFit.fill
            )
          ),
        ),
      ),
    ),
  );
}