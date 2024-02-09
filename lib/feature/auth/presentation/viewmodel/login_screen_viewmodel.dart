import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
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
    final session = await ref.read(authDomainControllerProvider.notifier).socialSignInWithGoogle();
    if(session != null) {
      ref.read(userDomainControllerProvider.notifier).getUserInfo(session: session);
      ShowDialogHelper.closeLoading();
      AppRouter.pushAndReplaceNamed(Routes.homeScreenRoute);
    } else {
      ShowDialogHelper.showAlert(title: "알림", message: "구글 로그인에 실패하였습니다");
    }
  }

  void handlePressedSignInApple() {
    ref.read(authDomainControllerProvider.notifier).socialSignInWithApple();
  }
}