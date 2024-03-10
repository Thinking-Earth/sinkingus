import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

Row chatInputter({
  required TextEditingController textController, 
  required FocusNode focusNode,
  required VoidCallback onTap
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children : [
      Expanded(
        child : TextField(
          controller : textController,
          focusNode: focusNode,
          style : AppTypography.whitePixel,
          autofocus: true,
          decoration : InputDecoration(
            hintText : '채팅을 입력하세요.', 
            border : InputBorder.none, 
            hintStyle: AppTypography.whitePixel
          ),
        ),
      ),
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          highlightColor: AppColors.green20,
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(Icons.send_rounded, size: 14.w,)
          ),
        ),
      ),
      SizedBox(width: 4.w,)
    ],
  );
}