import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/home/viewmodel/home_screen_viewmodel.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class HomeScreen extends ConsumerStatefulWidget{
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
                const Spacer(flex: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: ref.read(homeScreenControllerProvider.notifier).handlePressedSearchRoom,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 100.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bgPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text("Build room", style: AppTypography.labelCute,),
                      ),
                    ),
                    InkWell(
                      onTap: ref.read(homeScreenControllerProvider.notifier).handlePressedSearchRoom,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 100.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bgPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text("Join room", style: AppTypography.labelCute,),
                      ),
                    )
                  ],
                ),
                const Spacer(flex: 3,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}