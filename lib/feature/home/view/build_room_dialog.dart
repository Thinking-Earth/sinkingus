import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/home/widgets/game_textfield.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildDialogContent extends ConsumerStatefulWidget {
  const BuildDialogContent({super.key});

  @override
  ConsumerState<BuildDialogContent> createState() => _BuildDialogContentState();
}

class _BuildDialogContentState extends ConsumerState<BuildDialogContent> {
  TextEditingController myController = TextEditingController();
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.searchPopUp),
                fit: BoxFit.fitWidth)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Container(
              width: 140.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.roomName), fit: BoxFit.fill)),
              child: Text(
                tr('build_room'),
                style: AppTypography
                    .blackPixel
                    .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            SizedBox(
              width: 280.w,
              child: gameTextField(
                controller: myController,
                hintText: tr('buildPage_hintText'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    value: _isPrivate,
                    checkColor: Colors.white,
                    activeColor: AppColors.black10,
                    onChanged: (value) {
                      setState(() {
                        _isPrivate = value!;
                      });
                    }),
                Text(
                  tr('buildPage_private'),
                  style: AppTypography
                      .blackPixel
                      .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const Spacer(
              flex: 3,
            ),
            InkWell(
              onTap: () {
                ref
                    .read(matchDomainControllerProvider.notifier)
                    .buildAndJoinMatch(
                        roomName: myController.text,
                        isPrivate: _isPrivate ? "private" : "public");
                Navigator.of(context).pop();
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
                        fit: BoxFit.fill)),
                child: Text(
                  tr('buildPage_createBtn'),
                  style: AppTypography.blackPixel,
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
