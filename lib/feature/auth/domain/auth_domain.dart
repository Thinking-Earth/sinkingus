import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nakama/nakama.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/auth/data/dataSource/auth_data_source.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'auth_domain.g.dart';

class AuthDomainState {
  AuthDomainState({
    required this.authDataSource,
    this.session,
    this.socket
  });

  AuthDataSource authDataSource;
  Session? session;
  NakamaWebsocketClient? socket;
}

@Riverpod(keepAlive: true)
class AuthDomainController extends _$AuthDomainController {
  Timer? _timer;

  @override
  AuthDomainState build() {
    _timer ??= Timer.periodic(const Duration(hours: 1), (_) async {
      if(state.session != null) {
        state.session = await state.authDataSource.refreshSession(session: state.session!);
      }
    });
    return AuthDomainState(
      authDataSource: AuthDataSource()
    );
  }

  void setState() {
    state = AuthDomainState(
      authDataSource: state.authDataSource,
      session: state.session,
      socket: state.socket
    );
  }

  // session
  Future<void> logOutSession() async {
    if(state.session != null) {
      await state.authDataSource.logOutSession(session: state.session!);
    }
    state.session = null;
    state.socket = null;
    setState();
  }

  // socket
  Future<void> getSocket() async {
    if(state.session != null) {
      state.socket = state.authDataSource.buildSocket(token: state.session!.token);
      setState();
    } else {
      throw Exception("Session이 비어있는 상태로 Socket을 불러올 수 없습니다.");
    }
  }

  // auth
  Future<Session?> socialSignInWithGoogle() async {
    try {
      GoogleSignInAccount? result = kIsWeb ? await (GoogleSignIn().signInSilently()) : await GoogleSignIn().signIn();
      if(kIsWeb && result == null) result = await GoogleSignIn().signIn();
      if(result != null) {
        GoogleSignInAuthentication? googleAuth = await result.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
        );
        //Session userSession = await state.authDataSource.socialLoginWithGoogle(token: googleAuth.idToken!);
        Session userSession = await state.authDataSource.socialLoginWithGoogle(userInfo: UserInfoModel(
          email: result.email,
          nick: result.displayName ?? "worker ${Random().nextInt(900000) + 100000}",
          profileURL: result.photoUrl ?? "https://k.kakaocdn.net/dn/1G9kp/btsAot8liOn/8CWudi3uy07rvFNUkk3ER0/img_640x640.jpg",
          uid: result.id
        ));
        await FirebaseAuth.instance.signInWithCredential(credential);
        state.session = userSession;
        getSocket();
        return userSession;
      } else {
        ShowDialogHelper.showAlert(title: "오류", message: "구글 로그인 실패");
      }
    } catch (e) {
      ShowDialogHelper.showAlert(title: "오류", message: e.toString());
    }
    return null;
  }

  Future<void> socialSignInWithApple() async {

  }
}