import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/auth/presentation/viewmodel/login_screen_viewmodel.dart';
import 'package:sinking_us/feature/auth/presentation/widgets/custom_login_btn.dart';
import 'package:sinking_us/helpers/constants/app_svgs.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class LoginScreen extends ConsumerStatefulWidget{
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 844.w,),
          const Spacer(flex: 8,),
          customLoginBtn(
            onTap: ref.read(loginScreenControllerProvider.notifier).handlePressedSignInGoogle,
            svg: AppSvgs.googleIcon,
            backColor: Colors.white,
            text: "Sign in with Google",
            style: AppTypography.body2.copyWith(fontWeight: FontWeight.w500)
          ),
          SizedBox(height: 12.h,),
          customLoginBtn(
            onTap: ref.read(loginScreenControllerProvider.notifier).handlePressedSignInApple,
            svg: AppSvgs.appleIcon,
            backColor: Colors.black,
            text: "Sign in with Apple",
            style: AppTypography.body2.copyWith(fontWeight: FontWeight.w500, color: Colors.white)
          ),
          const Spacer(flex: 2,)
        ],
      ),
    );
  }
}