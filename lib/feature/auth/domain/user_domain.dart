import 'package:nakama/nakama.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/auth/data/dataSource/user_data_source.dart';

part 'user_domain.g.dart';

class UserDomainState {
  UserDomainState({this.userData});

  Account? userData;
}

@Riverpod(keepAlive: true)
class UserDomainController extends _$UserDomainController {
  @override
  UserDomainState build() {
    return UserDomainState();
  }

  void setState() {
    state = UserDomainState(
      userData: state.userData
    );
  }

  Future<void> getUserInfo({required Session session}) async {
    state.userData = await UserDataSource().getUserInfo(session: session);
    setState();
  }
}