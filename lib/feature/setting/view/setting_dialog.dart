import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/home/widgets/game_textfield.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingDialogContent extends ConsumerStatefulWidget {
  const SettingDialogContent({super.key});

  @override
  ConsumerState<SettingDialogContent> createState() => _BuildDialogContentState();
}

class _BuildDialogContentState extends ConsumerState<SettingDialogContent> {
  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.searchPopUp),
            fit: BoxFit.fitWidth
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 140.w,
              height: 40.h,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40.h),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.roomName),
                  fit: BoxFit.fill
                )
              ),
              child: Text(
                'Setting', 
                style: AppTypography.blackPixel.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 16.h,),
            Row(
              children: [
                Text(
                  tr('settingPage_language'), 
                  style: AppTypography.blackPixel.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
            const Spacer(flex: 3,),
            InkWell(
              onTap: () {
        
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 100.w,
                height: 30.h,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppImages.searchBtn,
                    ),
                    fit: BoxFit.fill
                  )
                ),
                child: Text(
                  tr('buildPage_createBtn'),
                  style: AppTypography.blackPixel,
                ),
              ),
            ),
            const Spacer(flex: 1,),
          ],
        ),
      ),
    );
  }
}
