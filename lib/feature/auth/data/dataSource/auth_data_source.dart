import 'package:sinking_us/core/network/firestore_base.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';

class AuthDataSource {
  
  // auth
  Future<UserInfoModel?> getUserInfoFromFirestore({required String email}) async {
    return await FirestoreBase().getUserInfo(email: email);
  }

  Future<void> socialLoginWithGoogle({required UserInfoModel userInfo}) async {
    await FirestoreBase().signInFirestore(userInfo: userInfo);
  }

  Future<void> socialLoginWithApple({required UserInfoModel userInfo}) async {
    await FirestoreBase().signInFirestore(userInfo: userInfo);
  }
}