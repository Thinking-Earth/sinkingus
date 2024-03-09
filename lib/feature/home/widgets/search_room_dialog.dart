import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/home/widgets/match_list_item.dart';

class SearchDialogContent extends StatefulWidget {
  const SearchDialogContent({super.key});

  @override
  State<SearchDialogContent> createState() => _SearchDialogContentState();
}

class _SearchDialogContentState extends State<SearchDialogContent> {
  TextEditingController myController = TextEditingController();
  Map<String, Match> matchList = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            controller: myController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Input your private room name',
            )),
        IconButton(
            onPressed: () async {
              final snapshot =
                  await FirebaseDatabase.instance.ref("lobby/private").get();

              (snapshot.value as Map<String, dynamic>).forEach((key, value) {
                var match = Match.fromJson(value as Map<String, dynamic>);
                if (match.roomName == myController.text) {
                  setState(() {
                    matchList[key] = match;
                  });
                }
              });
            },
            icon: const Icon(Icons.search)),
        SizedBox(
          width: 350.w,
          height: 200.h,
          child: ListView.builder(
              itemCount: matchList.length,
              itemBuilder: (context, index) {
                String matchId = matchList.keys.elementAt(index);
                return MatchListItem(
                    matchId: matchId,
                    match: matchList[matchId]!,
                    isPrivate: "private");
              }),
        )
      ],
    );
  }
}
