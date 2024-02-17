import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/home/model/match_info.dart';
import 'package:sinking_us/feature/home/view/match_list_item.dart';
import 'package:sinking_us/feature/home/viewmodel/home_screen_viewmodel.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, Match> matchList = {};

  _HomeScreenState() {
    FirebaseDatabase.instance.ref('lobby/public').onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        final newMatch =
            Match.fromJson(event.snapshot.value as Map<String, dynamic>);
        setState(() {
          matchList[event.snapshot.key!] = newMatch;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 400.w,
            height: 390.h,
            color: Colors.red,
          ),
          SizedBox(
            width: 400.w,
            child: Column(
              children: [
                Container(
                  width: 400.w,
                  height: 230.h,
                  color: Colors.blueGrey[300],
                  child: ListView.builder(
                    itemCount: matchList.length,
                    itemBuilder: (context, index) {
                      return MatchListItem(matchList.values.elementAt(index));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: ref
                          .read(homeScreenControllerProvider.notifier)
                          .handlePressedBuildRoom,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 100.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bgPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Build room",
                          style: AppTypography.labelCute,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: ref
                          .read(homeScreenControllerProvider.notifier)
                          .handlePressedSearchRoom,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 100.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bgPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Join room",
                          style: AppTypography.labelCute,
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
