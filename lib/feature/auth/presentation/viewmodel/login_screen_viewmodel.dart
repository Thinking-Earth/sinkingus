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
      AppRouter.pushAndReplaceNamed(Routes.homeScreenRoute);
    } else {
      ShowDialogHelper.showAlert(title: "알림", message: "구글 로그인에 실패하였습니다");
    }
  }

  void handlePressedSignInApple() async {
    ShowDialogHelper.showLoading();
    final UserInfoModel? userInfo = await ref.read(authDomainControllerProvider.notifier).socialSignInWithApple();
    if(userInfo != null) {
      ref.read(userDomainControllerProvider.notifier).setUserInfo(userInfo: userInfo);
      ShowDialogHelper.closeLoading();
      AppRouter.pushAndReplaceNamed(Routes.homeScreenRoute);
    } else {
      ShowDialogHelper.showAlert(title: "알림", message: "애플 로그인에 문제가 발생하였습니다. 다시 한번 시도하거나 다른 로그인 방법으로 시도해주세요.");
    }
    ref.read(authDomainControllerProvider.notifier).socialSignInWithApple();
  }
}