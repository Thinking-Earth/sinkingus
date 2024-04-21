import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/home/widgets/show_character.dart';
import 'package:sinking_us/feature/result/viewmodel/result_viewmodel.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  bool charactorController = false;
  bool circleAnimation = false;
  String endText = "";
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
        setState(() {
          charactorController = !charactorController;
        });
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          circleAnimation = true;
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
    final status = ref.watch(resultViewModelControllerProvider).status;
    if (status == 'win') {
      endText = tr('result_win');
    } else if (status == 'hp die') {
      endText = tr('result_dead');
    } else if (status == 'nature die') {
      endText = tr('result_nature');
    } else {
      endText = tr('result_dead');
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 844.w,
            height: 390.h,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 7800),
            curve: Curves.fastEaseInToSlowEaseOut,
            width: circleAnimation ? 260.w : 1400,
            height: circleAnimation ? 260.h : 1400,
            decoration: BoxDecoration(
                borderRadius:
                    circleAnimation ? BorderRadius.circular(300) : null,
                image: const DecorationImage(
                    image: AssetImage('assets/images/map1.png'),
                    fit: BoxFit.none),
                boxShadow: [
                  BoxShadow(
                      color:
                          status == 'win' ? Colors.grey.shade100 : Colors.red,
                      blurRadius: 20.w,
                      spreadRadius: 2.w)
                ]),
          ),
          SizedBox(
            width: 280.w,
            height: 280.h,
            child: Stack(
              children: [
                Positioned(
                  right: 20.w,
                  top: 98.h,
                  child: showCharacter(
                      onTap: () {},
                      move: charactorController,
                      imageAsset: AppImages.businessMan),
                ),
                Positioned(
                  right: 60.w,
                  top: 120.h,
                  child: showCharacter(
                      onTap: () {},
                      move: charactorController,
                      imageAsset: AppImages.politicianMan),
                ),
                Positioned(
                  left: 60.w,
                  top: 120.h,
                  child: showCharacter(
                      onTap: () {},
                      move: charactorController,
                      flip: true,
                      imageAsset: AppImages.natureMan),
                ),
                Positioned(
                  left: 20.w,
                  top: 100.h,
                  child: showCharacter(
                      onTap: () {},
                      move: charactorController,
                      flip: true,
                      imageAsset: AppImages.workerMan),
                ),
              ],
            ),
          ),
          Positioned(
            top: 2.h,
            child: Text(
              endText,
              style: AppTypography().blackPixel.copyWith(
                  color: status == 'win' ? Colors.amber[400] : Colors.red,
                  fontSize: 40.sp),
            ),
          ),
          Positioned(
            top: 4.h,
            right: 4.w,
            child: IconButton(
              onPressed: () {
                AppRouter.pop();
              },
              icon: const Icon(
                CupertinoIcons.xmark,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
