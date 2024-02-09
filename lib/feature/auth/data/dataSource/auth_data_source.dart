import 'package:nakama/nakama.dart';
import 'package:sinking_us/core/network/nakama_service.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';

class AuthDataSource {

  Future<Session> socialLoginWithGoogle({required UserInfoModel userInfo}) async {
    return await NakamaService().signInWithCustom(userInfo: userInfo);
  }

  Future<Session> socialLoginWithApple({required UserInfoModel userInfo}) async {
    return UnimplementedError() as Session;
  }
}