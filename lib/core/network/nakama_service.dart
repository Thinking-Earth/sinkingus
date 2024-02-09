import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';

late NakamaBaseClient _nakamaClient;

@immutable
class NakamaService {
  NakamaService(){
    _nakamaClient = getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
      httpPort: 7350
    );
  }

  Future<Account> getNakamaAccount({required Session session}) async {
    return await _nakamaClient.getAccount(session);
  }

  Future<List<User>> getOtherUserAccount({required Session session}) async {
    return await _nakamaClient.getUsers(session: session);
  }

  Future<Session> signInWithGoogle({required String token}) async {
    Session session = await _nakamaClient.authenticateGoogle(token: token);
    return session;
  }

  Future<Session> signInWithCustom({
    required UserInfoModel userInfo,
  }) async {
    Session session = await _nakamaClient.authenticateCustom(
      id: userInfo.uid,
      username: userInfo.nick,
    );
    _nakamaClient.updateAccount(
      session: session,
      avatarUrl: userInfo.profileURL,
      username: userInfo.nick,
      displayName: userInfo.nick,
    );
    return session;
  }
}