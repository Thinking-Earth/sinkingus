// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoModelImpl _$$UserInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoModelImpl(
      email: json['email'] as String,
      nick: json['nick'] as String,
      profileURL: json['profileURL'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$$UserInfoModelImplToJson(_$UserInfoModelImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'nick': instance.nick,
      'profileURL': instance.profileURL,
      'uid': instance.uid,
    };
