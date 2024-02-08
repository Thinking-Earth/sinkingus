import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nakama/nakama.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/auth/data/dataSource/auth_data_source.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'auth_domain.g.dart';

class AuthDomainState {
  AuthDomainState({required this.authDataSource});

  AuthDataSource authDataSource;
}

@riverpod
class AuthDomainController extends _$AuthDomainController {
  @override
  AuthDomainState build() {
    return AuthDomainState(
      authDataSource: AuthDataSource()
    );
  }

  void setState() {
    state = AuthDomainState(
      authDataSource: state.authDataSource
    );
  }

  Future<Session?> socialSignInWithGoogle() async {
    try {
      await GoogleSignIn().signIn().then((result) async {
        if(result != null){
          Session userSession = await state.authDataSource.socialLoginWithGoogle(userInfo: UserInfoModel(
            email: result.email,
            nick: result.displayName ?? "worker ${Random().nextInt(900000) + 100000}",
            profileURL: result.photoUrl ?? "https://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
            uid: result.id
          ));
          print("eeeee $userSession");
          //await FirebaseAuth.instance.signInWithCustomToken(result.id);
          return userSession;
        } else {
          print("fuckkk??");
          ShowDialogHelper.showAlert(title: "오류", message: "구글 로그인 실패");
        }
      });
    } catch (e) {
      ShowDialogHelper.showAlert(title: "오류", message: e.toString());
    }
    return null;
  }

  Future<void> socialSignInWithApple() async {

  }
}