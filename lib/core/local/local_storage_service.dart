import 'package:sinking_us/core/local/local_storage_base.dart';

class LocalStorageService {
  static const _authTokenKey = 'authToken';

  final _keyValueStorage = LocalStorageBase();

  Future<String> getAuthToken() async {
    return await _keyValueStorage.getEncrypted(_authTokenKey) ?? '';
  }

  void setAuthToken(String token) {
    _keyValueStorage.setEncrypted(_authTokenKey, token);
  }

  void resetKeys() {
    _keyValueStorage
      ..clearCommon()
      ..clearEncrypted();
  }
}
