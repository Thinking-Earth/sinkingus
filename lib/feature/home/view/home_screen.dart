import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/home/viewmodel/home_screen_viewmodel.dart';
import 'package:sinking_us/feature/home/widgets/game_block_btn.dart';
import 'package:sinking_us/feature/home/widgets/match_list_item.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, Match> matchList = {};
  bool charactorController = false;

  void refreshMatchList() async {
    ref.read(matchDomainControllerProvider.notifier).checkNotInMatch();
    matchList =
        await ref.read(matchDomainControllerProvider.notifier).getMatchList();
    setState(() {
      matchList = matchList;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshMatchList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF80E6EF),
        body: Stack(
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
                        right: 100.w,
                        top: 110.h,
                        child: showCharactor(),
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
                            style: AppTypography.blackPixel.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          InkWell(
                            onTap: refreshMatchList,
                            child: Image.asset(AppImages.refreshIcon),
                          )
                        ],
                      ),
                      SizedBox(height: 8.h,),
                      SizedBox(
                        width: 400.w,
                        height: 230.h,
                        child: matchList.isNotEmpty 
                          ? ListView.builder(
                              itemCount: matchList.length,
                              itemBuilder: (context, index) {
                                String matchId = matchList.keys.elementAt(index);
                                return MatchListItem(
                                    matchId: matchId,
                                    match: matchList[matchId]!,
                                    isPrivate: "public");
                              },
                            )
                          : Center(
                              child: Text(
                                "There are no rooms left.\nCreate a room and enjoy the game!",
                                textAlign: TextAlign.center,
                                style: AppTypography.blackPixel,
                              ),
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          gameBlockBtn(
                            text: tr('build_room'),
                            onTap: ref
                                .read(homeScreenControllerProvider.notifier)
                                .handlePressedBuildRoom,
                          ),
                          gameBlockBtn(
                            text: tr("join_room"), 
                            onTap: ref
                                .read(homeScreenControllerProvider.notifier)
                                .handlePressedSearchRoom,
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
    );
  }
}
