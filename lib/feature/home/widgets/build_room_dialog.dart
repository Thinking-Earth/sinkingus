import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

// ignore: must_be_immutable
class BuildDialogContent extends StatelessWidget {
  BuildDialogContent({required this.setState, super.key});

  final myController = TextEditingController();
  final StateSetter setState;
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
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
              const Text("Private Room")
            ],
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
    });
  }
}
