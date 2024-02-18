import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
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
            onTap: () async {
              await ref
                  .read(matchDomainControllerProvider.notifier)
                  .buildMatch(
                      roomName: myController.text, isPrivate: _isPrivate)
                  .then((value) =>
                      AppRouter.pushNamed(Routes.gameMainScreenRoute));
              print("haha lala");
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
