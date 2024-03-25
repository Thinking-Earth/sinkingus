import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/auth/domain/auth_domain.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'login_screen_viewmodel.g.dart';

class LoginScreenState {
  LoginScreenState();
}

@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  LoginScreenState build() {
    return LoginScreenState();
  }

  void setState() {
    state = LoginScreenState();
  }

  void handlePressedSignInGoogle() async {
    ShowDialogHelper.showLoading();
    final UserInfoModel? userInfo = await ref.read(authDomainControllerProvider.notifier).socialSignInWithGoogle();
    if(userInfo != null) {
      ref.read(userDomainControllerProvider.notifier).setUserInfo(userInfo: userInfo);
      ShowDialogHelper.closeLoading();
      // AppRouter.pushAndReplaceNamed(Routes.homeScreenRoute);
    } else {
      ShowDialogHelper.showAlert(title: tr('noti_noti'), message: tr('noti_fail_google'));
    }
  }

  void handlePressedSignInApple() async {
    ShowDialogHelper.showLoading();
    final UserInfoModel? userInfo = await ref.read(authDomainControllerProvider.notifier).socialSignInWithApple();
    if(userInfo != null) {
      ref.read(userDomainControllerProvider.notifier).setUserInfo(userInfo: userInfo);
      ShowDialogHelper.closeLoading();
      // AppRouter.pushAndReplaceNamed(Routes.homeScreenRoute);
    } else {
      ShowDialogHelper.showAlert(title: tr('noti_noti'), message: tr('noti_fail_apple'));
    }
    ref.read(authDomainControllerProvider.notifier).socialSignInWithApple();
  }

  void handlePressedFakeLogin() {
    ShowDialogHelper.showLoading();
    const UserInfoModel userInfo = UserInfoModel(
      email: "tester@gamil.com", 
      nick: "tester", 
      profileURL: "", 
      uid: "TestingUser"
    );
    ref.read(userDomainControllerProvider.notifier).setUserInfo(userInfo: userInfo);
    ShowDialogHelper.closeLoading();
  }
}