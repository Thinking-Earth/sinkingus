import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class BuildDialogContent extends StatefulWidget {
  const BuildDialogContent({super.key});

  @override
  State<BuildDialogContent> createState() => _BuildDialogContentState();
}

class _BuildDialogContentState extends State<BuildDialogContent> {
  bool _isPrivate = false;
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            controller: myController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Input your room name',
            )),
        Row(
          children: [
            Checkbox(
                value: _isPrivate,
                onChanged: (value) {
                  setState(() {
                    _isPrivate = value!;
                  });
                }),
            Text("Private Room")
          ],
        ),
        InkWell(
          onTap: () async {
            final newMatchId =
                FirebaseDatabase.instance.ref("lobby").push().key;
            await FirebaseDatabase.instance
                .ref("lobby/${_isPrivate ? "private" : "public"}/$newMatchId")
                .set({
              "roomName": myController.text,
              "playerCount": 1,
            });
            await FirebaseDatabase.instance.ref("game/$newMatchId").set({
              "roomName": myController.text,
              "host": "my uid",
              "players": [
                {
                  "name": "eunzee",
                  "uid": "my uid",
                  "role": "default",
                  "position": [0, 0]
                }
              ],
              "day": 0,
              "item": [1, 0],
              "rule": "default rule",
            });
            // start game as a host
            print("create match: $newMatchId");
            AppRouter.pushNamed(Routes.gameMainScreenRoute);
          },
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
      ],
    );
  }
}
