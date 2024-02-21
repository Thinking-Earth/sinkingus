import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';

part 'user_domain.g.dart';

class UserDomainState {
  UserDomainState({this.userData});

  UserInfoModel? userData;
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

  Future<void> setUserInfo({required UserInfoModel userInfo}) async {
    state.userData = userInfo;
    setState();
  }
}