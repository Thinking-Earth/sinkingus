import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_model.freezed.dart';
part 'user_info_model.g.dart';

@freezed
class UserInfoModel with _$UserInfoModel {
  //조심하셈 nakama string만 먹음
  const factory UserInfoModel({
    required String email,
    required String nick,
    required String profileURL,
    required String uid,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
}
