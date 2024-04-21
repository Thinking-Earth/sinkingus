import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/chats/data/model/chat_model.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

Widget serverChatBubble(ChatModel chat) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
        child: Text(chat.content,
            style: AppTypography()
                .whitePixel
                .copyWith(fontWeight: FontWeight.w600)),
      ),
    ),
  );
}
