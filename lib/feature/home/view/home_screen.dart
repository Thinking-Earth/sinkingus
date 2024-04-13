import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/home/viewmodel/home_screen_viewmodel.dart';
import 'package:sinking_us/feature/home/widgets/game_block_btn.dart';
import 'package:sinking_us/feature/home/widgets/match_list_item.dart';
import 'package:sinking_us/feature/home/widgets/show_character.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, Match> matchList = {};
  String bottomText = tr('game_description');
  bool charactorController = false;
  late Timer _timer;

  void refreshMatchList() async {
    ref.read(matchDomainControllerProvider.notifier).checkNotInMatch();
    matchList = await ref.read(matchDomainControllerProvider.notifier).getMatchList();
    setState(() {
      matchList = matchList;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshMatchList();
      _timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
        setState(() {
          charactorController = !charactorController;
        });
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF80E6EF),
        body: GestureDetector(
          onTap: () {
            setState(() {
              bottomText = tr('game_description');
            });
          },
          child: Stack(
            children: [
              Image.asset(
                AppImages.homeBg,
                width: 844.w,
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //왼쪽
                  SizedBox(
                    width: 380.w,
                    height: 390.h,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 0,
                            top: 0,
                            child: IconButton(
                              onPressed: ref.read(homeScreenControllerProvider.notifier).handleSetting,
                              icon: const Icon(
                                Icons.settings,
                                color: AppColors.black10,
                              ),
                            )),
                        Positioned(
                          right: 62.w,
                          top: 108.h,
                          child: showCharacter(
                              onTap: () {
                                setState(() {
                                  bottomText = tr('business_description');
                                });
                              },
                              move: charactorController,
                              imageAsset: AppImages.businessMan),
                        ),
                        Positioned(
                          right: 125.w,
                          top: 110.h,
                          child: showCharacter(
                              onTap: () {
                                setState(() {
                                  bottomText = tr('politician_description');
                                });
                              },
                              move: charactorController,
                              imageAsset: AppImages.politicianMan),
                        ),
                        Positioned(
                          left: 95.w,
                          top: 110.h,
                          child: showCharacter(
                              onTap: () {
                                setState(() {
                                  bottomText = tr('nature_description');
                                });
                              },
                              move: charactorController,
                              flip: true,
                              imageAsset: AppImages.natureMan),
                        ),
                        Positioned(
                          left: 29.w,
                          top: 110.h,
                          child: showCharacter(
                              onTap: () {
                                setState(() {
                                  bottomText = tr('worker_description');
                                });
                              },
                              move: charactorController,
                              flip: true,
                              imageAsset: AppImages.workerMan),
                        ),
                        Positioned(
                          left: 48.w,
                          bottom: 24.h,
                          child: SizedBox(
                            width: 256.w,
                            height: 102.h,
                            child: SingleChildScrollView(
                              child: Text(
                                bottomText,
                                style: AppTypography.blackPixel.copyWith(fontSize: 12.sp),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 380.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr('homePage_listWorld'),
                              style: AppTypography.blackPixel.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: refreshMatchList,
                              child: Image.asset(AppImages.refreshIcon),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        SizedBox(
                          width: 400.w,
                          height: 230.h,
                          child: matchList.isNotEmpty
                              ? ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(
                                    dragDevices: {
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse,
                                      PointerDeviceKind.trackpad,
                                    },
                                  ),
                                  child: ListView.builder(
                                    itemCount: matchList.length,
                                    itemBuilder: (context, index) {
                                      String matchId = matchList.keys.elementAt(index);
                                      return MatchListItem(matchId: matchId, match: matchList[matchId]!, isPrivate: "public");
                                    },
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "There are no rooms left.\nCreate a room and enjoy the game!",
                                    textAlign: TextAlign.center,
                                    style: AppTypography.blackPixel.copyWith(fontSize: 10.sp),
                                  ),
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            gameBlockBtn(
                              text: tr('build_room'),
                              onTap: ref.read(homeScreenControllerProvider.notifier).handlePressedBuildRoom,
                            ),
                            gameBlockBtn(
                              text: tr("join_room"),
                              onTap: ref.read(homeScreenControllerProvider.notifier).handlePressedSearchRoom,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
