import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/home/widgets/game_textfield.dart';
import 'package:sinking_us/feature/home/widgets/match_list_item.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class SearchDialogContent extends StatefulWidget {
  const SearchDialogContent({super.key});

  @override
  State<SearchDialogContent> createState() => _SearchDialogContentState();
}

class _SearchDialogContentState extends State<SearchDialogContent> {
  TextEditingController myController = TextEditingController();
  Map<String, Match> matchList = {};
  String infoText = tr("searchPage_infoText");

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 280.w,
                  child: gameTextField(
                    controller: myController, 
                    hintText: tr('searchPage_hintText'),
                    onSubmitted: searchRoom
                  ),
                ),
                InkWell(
                  onTap: searchRoom,
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.searchIcon),
                        fit: BoxFit.fitWidth
                      )
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 350.w,
              height: 200.h,
              child: matchList.isNotEmpty 
                ? ListView.builder(
                  itemCount: matchList.length,
                  itemBuilder: (context, index) {
                    String matchId = matchList.keys.elementAt(index);
                    return MatchListItem(
                        matchId: matchId,
                        match: matchList[matchId]!,
                        isPrivate: "private");
                  })
                : Center(child: Text(infoText, style: AppTypography.blackPixel,)),
            )
          ],
        ),
      ),
    );
  }

  void searchRoom() async {
    FocusScope.of(context).unfocus();
    final snapshot = await FirebaseDatabase.instance.ref("lobby/private").get();
    if(snapshot.exists) {
      (Map<String, dynamic>.from(snapshot.value as Map)).forEach((key, value) {
        var match = Match.fromJson(Map<String, dynamic>.from(value as Map));
        if (match.roomName == myController.text) {
          setState(() {
            matchList[key] = match;
          });
        }
      });
    } else {
      setState(() {
        infoText = tr("searchPage_info_notFound");
      });
    }
  }
}
