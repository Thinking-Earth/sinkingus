import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/auth/presentation/viewmodel/login_screen_viewmodel.dart';
import 'package:sinking_us/feature/auth/presentation/widgets/custom_login_btn.dart';
import 'package:sinking_us/helpers/constants/app_images.dart';
import 'package:sinking_us/helpers/constants/app_svgs.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late Timer _timer;
  double opacityController = 1;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      setState(() {
        opacityController = opacityController == 1 ? 0 : 1;
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
    final userInfo = ref.read(userDomainControllerProvider).userInfo;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            if (userInfo != null) {
              AppRouter.pushAndReplaceNamed(Routes.homeScreenRoute);
            }
          },
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppImages.loginBg), fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 844.w,
                ),
                const Spacer(
                  flex: 8,
                ),
                userInfo == null
                    ? Column(
                        children: [
                          customLoginBtn(
                            onTap: ref
                                .read(loginScreenControllerProvider.notifier)
                                .handlePressedSignInGoogle,
                            svg: AppSvgs.googleIcon,
                            backColor: Colors.white,
                            text: "Sign in with Google",
                            style: AppTypography.blackPixel.copyWith(
                              fontSize: 12.sp, fontWeight: FontWeight.w500)
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          customLoginBtn(
                              onTap: ref
                                  .read(loginScreenControllerProvider.notifier)
                                  .handlePressedSignInApple,
                              svg: AppSvgs.appleIcon,
                              backColor: Colors.black,
                              text: "Sign in with Apple",
                              style: AppTypography.whitePixel.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                          SizedBox(
                            height: 12.h,
                          ),
                          customLoginBtn(
                            onTap: ref
                                .read(loginScreenControllerProvider.notifier)
                                .handlePressedSignInApple,
                            svg: AppSvgs.googleIcon,
                            backColor: Colors.white,
                            text: "Evaluator Only judges Login",
                            style: AppTypography.blackPixel.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            )
                          ),
                        ],
                      )
                    : AnimatedOpacity(
                        opacity: opacityController,
                        duration: const Duration(milliseconds: 280),
                        child: Text(
                          '- Touch to Start -',
                          style: AppTypography.whitePixel.copyWith(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                const Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
