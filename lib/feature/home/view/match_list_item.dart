import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/home/model/match_info.dart';

class MatchListItem extends StatelessWidget {
  const MatchListItem(this.match, {super.key});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Center(
          child: Row(
        children: [
          Text(match.roomName),
          const Spacer(
            flex: 2,
          ),
          Text(
            "${match.playerCount}/10",
          )
        ],
      )),
    );
  }
}
