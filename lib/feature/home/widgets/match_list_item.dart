import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class MatchListItem extends StatelessWidget {
  const MatchListItem(
      {required this.matchId,
      required this.match,
      required this.isPrivate,
      super.key});

  final String matchId;
  final Match match;
  final String isPrivate;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return InkWell(
        child: Container(
          height: 50.h,
          margin: EdgeInsets.symmetric(vertical: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.gameListTile), fit: BoxFit.fill),
            // borderRadius: BorderRadius.circular(8.w),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.white,
            //     blurRadius: 2.w,
            //     spreadRadius: 4.w
            //   )
            // ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                match.roomName,
                style: AppTypography
                    .blackPixel
                    .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                "${match.playerCount}/6",
                style: AppTypography
                    .blackPixel
                    .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        onTap: () {
          ref
              .read(matchDomainControllerProvider.notifier)
              .joinMatch(matchId: matchId, isPrivate: isPrivate);
        },
      );
    });
  }
}
