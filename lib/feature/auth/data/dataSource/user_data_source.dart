import 'package:nakama/nakama.dart';
import 'package:sinking_us/core/network/nakama_service.dart';

class UserDataSource {
  UserDataSource();

  Future<Account> getUserInfo({required Session session}) async {
    return await NakamaService().getNakamaAccount(session: session);
  }
}