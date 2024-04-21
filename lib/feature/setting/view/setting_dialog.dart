import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/home/viewmodel/home_screen_viewmodel.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingDialogContent extends ConsumerStatefulWidget {
  const SettingDialogContent({super.key});

  @override
  ConsumerState<SettingDialogContent> createState() =>
      _SettingDialogContentState();
}

class _SettingDialogContentState extends ConsumerState<SettingDialogContent> {
  TextEditingController myController = TextEditingController();
  String dropdownvalue = tr("showing_language");

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
            Container(
              width: 140.w,
              height: 40.h,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40.h),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.roomName), fit: BoxFit.fill)),
              child: Text(
                'Setting',
                style: AppTypography
                    .blackPixel
                    .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  tr('settingPage_language'),
                  style: AppTypography
                      .blackPixel
                      .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                DropdownButton(
                    value: dropdownvalue,
                    items: [
                      'English - US',
                      '한국어 - KR',
                      '日本語 - JP',
                      'Español - ES',
                      'Tiếng Việt - VN',
                      '中国 - CN'
                    ].map<DropdownMenuItem>((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == '한국어 - KR') {
                        EasyLocalization.of(context)!
                            .setLocale(const Locale('ko', 'KR'));
                      } else if (value == '日本語 - JP') {
                        EasyLocalization.of(context)!
                            .setLocale(const Locale('ja', 'JP'));
                      } else if (value == 'Español - ES') {
                        EasyLocalization.of(context)!
                            .setLocale(const Locale('es', 'ES'));
                      } else if (value == 'Tiếng Việt - VN') {
                        EasyLocalization.of(context)!
                            .setLocale(const Locale('vi', 'VN'));
                      } else if (value == '中国 - CN') {
                        EasyLocalization.of(context)!
                            .setLocale(const Locale('zh', 'CN'));
                      } else {
                        EasyLocalization.of(context)!
                            .setLocale(const Locale('en', 'US'));
                      }
                      setState(() {
                        dropdownvalue = value;
                      });
                      ref.read(homeScreenControllerProvider.notifier).handleBottomText(tr('game_description'));
                    }),
              ],
            ),
            const Spacer(
              flex: 3,
            ),
            const AboutListTile(),
            const Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
