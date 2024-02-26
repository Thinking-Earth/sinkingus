import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';

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
