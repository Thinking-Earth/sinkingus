import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sinking_us/feature/auth/data/dataSource/auth_data_source.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'auth_domain.g.dart';

class AuthDomainState {
  AuthDomainState({
    required this.authDataSource
  });

  AuthDataSource authDataSource;
}

@Riverpod(keepAlive: true)
class AuthDomainController extends _$AuthDomainController {

  @override
  AuthDomainState build() {
    return AuthDomainState(
      authDataSource: AuthDataSource()
    );
  }

  void setState() {
    state = AuthDomainState(
      authDataSource: state.authDataSource,
    );
  }

  // auth
  Future<UserInfoModel?> getUserInfoFromServer({required String email}) async {
    return state.authDataSource.getUserInfoFromFirestore(email: email);
  }

  Future<UserInfoModel?> socialSignInWithGoogle() async {
    try {
      GoogleSignInAccount? result = kIsWeb ? await (GoogleSignIn().signInSilently()) : await GoogleSignIn().signIn();
      if(kIsWeb && result == null) result = await GoogleSignIn().signIn();
      if(result != null) {
        GoogleSignInAuthentication? googleAuth = await result.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
        );
        UserInfoModel userInfo =  UserInfoModel(
          email: result.email,
          nick: result.displayName ?? "worker ${Random().nextInt(900000) + 100000}",
          profileURL: result.photoUrl ?? "https://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
          uid: result.id
        );
        await state.authDataSource.socialLoginWithGoogle(userInfo: userInfo);
        await FirebaseAuth.instance.signInWithCredential(credential);
        return userInfo;
      } else {
        ShowDialogHelper.showAlert(title: "오류", message: "구글 로그인 실패");
      }
    } catch (e) {
      ShowDialogHelper.showAlert(title: "오류", message: e.toString());
    }
    return null;
  }

  Future<UserInfoModel?> socialSignInWithApple() async {
    try {
      final AuthorizationCredentialAppleID credentialAppleID = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ]
      );
      UserInfoModel userInfo = UserInfoModel(
        email: credentialAppleID.email ?? "AppleEmailError", 
        nick: "${credentialAppleID.familyName}${credentialAppleID.givenName}", 
        profileURL: "https://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
        uid: credentialAppleID.identityToken ?? credentialAppleID.email ?? "nouid"
      );
      final credential = OAuthProvider('apple.com').credential(
        idToken: credentialAppleID.identityToken,
        accessToken: credentialAppleID.authorizationCode
      );
      await state.authDataSource.socialLoginWithApple(userInfo: userInfo);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return userInfo;
    } catch (e) {
      ShowDialogHelper.showAlert(title: "오류", message: e.toString());
    }
    return null;
  }
}