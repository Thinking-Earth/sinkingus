import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/chats/data/model/chat_model.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

Widget myChatBubble(ChatModel chatData) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chatData.nick,
              style: AppTypography.whitePixel,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    (chatData.time as Timestamp)
                        .toDate()
                        .toString()
                        .substring(11, 16),
                    style: AppTypography.whitePixel.copyWith(
                        color: AppColors.black40,
                        fontWeight: FontWeight.normal,
                        fontSize: 8.sp)),
                SizedBox(
                  width: 4.w,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 168.w),
                  child: IntrinsicWidth(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: AppColors.black60,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8))),
                      child: Text(
                        chatData.content,
                        style: AppTypography
                            .blackPixel
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          width: 8.w,
        ),
        // Container(
        //   width: 38.w,
        //   height: 38.w,
        //   decoration: BoxDecoration(
        //     color: Colors.orange,
        //     borderRadius: BorderRadius.circular(8)
        //   ),
        // ),
      ],
    ),
  );
}
