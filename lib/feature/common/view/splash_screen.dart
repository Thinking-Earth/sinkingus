import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nakama/nakama.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/auth/domain/auth_domain.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/helpers/constants/app_svgs.dart';

class SplashScreen extends ConsumerStatefulWidget{
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          AppSvgs.appIcon,
          width: 80.w,
          height: 80.w,
        ),
      ),
    );
  }

  void initRoute() async {
    firebase.User? currentUser = firebase.FirebaseAuth.instance.currentUser;
    Session? session;

    if(currentUser != null) {
      session = await ref.read(authDomainControllerProvider.notifier).socialSignInWithGoogle();
    }
    
    //로그인 정보 없음
    if(session == null){
      AppRouter.pushAndReplaceNamed(Routes.loginScreenRoute);
      return;
    }

    await ref.read(userDomainControllerProvider.notifier).getUserInfo(session: session);
    AppRouter.pushAndReplaceNamed(Routes.homeScreenRoute);
  }
}