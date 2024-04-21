import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/auth/domain/auth_domain.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String loadingText = 'Loading';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(milliseconds: 580), (_) {
        if (loadingText == 'Loading') {
          setState(() {
            loadingText = 'Loading.';
          });
        } else if (loadingText == 'Loading.') {
          setState(() {
            loadingText = 'Loading..';
          });
        } else if (loadingText == 'Loading..') {
          setState(() {
            loadingText = 'Loading...';
          });
        } else {
          setState(() {
            loadingText = 'Loading';
          });
        }
      });
      Future.delayed(const Duration(seconds: 3), () {
        initRoute();
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset('assets/jsons/splash.json',
              width: 500.w, height: 500.h, fit: BoxFit.fill, repeat: false),
          Positioned(
            bottom: 40.h,
            child: Text(
              loadingText,
              style: AppTypography()
                  .whitePixel
                  .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          )
        ],
      )),
    );
  }

  void initRoute() async {
    firebase.User? currentUser = firebase.FirebaseAuth.instance.currentUser;
    UserInfoModel? userInfo;

    if (currentUser == null) {
      AppRouter.pushAndReplaceNamed(Routes.loginScreenRoute);
      return;
    }

    userInfo = await ref
        .read(authDomainControllerProvider.notifier)
        .getUserInfoFromServer(email: currentUser.email!);

    if (userInfo == null) {
      AppRouter.pushAndReplaceNamed(Routes.loginScreenRoute);
      return;
    }

    ref
        .read(userDomainControllerProvider.notifier)
        .setUserInfo(userInfo: userInfo);
    AppRouter.pushAndReplaceNamed(Routes.loginScreenRoute);
  }
}
