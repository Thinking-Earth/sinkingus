// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      nick: json['nick'] as String,
      content: json['content'] as String,
      role: json['role'] as String,
      time: json['time'],
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'content': instance.content,
      'role': instance.role,
      'time': instance.time,
    };
