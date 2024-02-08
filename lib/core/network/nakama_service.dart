import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';

@immutable
class NakamaService {
  NakamaService(){
    getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultKey',
      httpPort: 7350
    );
  }

  Future<Account> getNakamaAccount({required Session session}) async {
    return await getNakamaClient().getAccount(session);
  }

  Future<Session> signInWithCustom({
    required UserInfoModel userInfo,
  }) async {

    //TODO @전은지 . 구글 로그인 정보도 잘 들고오고 아무 문제 없음 저 nakama authEmail()에서 자꾸 이거 뜸 -> Error during authentication: Exception: Authentication failed.
    final client = getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultKey',
      grpcPort: 7350,
      httpPort: 7350
    );
    try {
      // Session session = await client.authenticateCustom(
      //   id: userInfo.uid,
      //   vars: {
      //     'email': userInfo.email,
      //     'nick': userInfo.nick,
      //     'profileURL': userInfo.profileURL,
      //     'uid': userInfo.uid,
      //   }
      // );
      Session test = await client.authenticateEmail(
        email: "test@gmail.com",
        password: "123456",
        create: true,
        username: "eeeee"
      );
      print("Session: $test"); // 세션 출력
      return test;
    } catch (e) {
      print("Error during authentication: $e"); // 오류 출력
      rethrow;
    }
  }
}