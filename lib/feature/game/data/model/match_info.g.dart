// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      roomName: json['roomName'] as String,
      playerCount: json['playerCount'] as int,
      isPrivate: json['isPrivate'] as bool?,
      players:
          (json['players'] as List<dynamic>?)?.map((e) => e as String).toList(),
      host: json['host'] as String?,
      day: json['day'] as int?,
      groceryList: (json['groceryList'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$GroceryTypeEnumMap, k), e as bool),
      ),
      gameEventList: (json['gameEventList'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      rule: $enumDecodeNullable(_$RuleTypeEnumMap, json['rule']),
    );

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'roomName': instance.roomName,
      'playerCount': instance.playerCount,
      'isPrivate': instance.isPrivate,
      'players': instance.players,
      'host': instance.host,
      'day': instance.day,
      'groceryList': instance.groceryList
          ?.map((k, e) => MapEntry(_$GroceryTypeEnumMap[k]!, e)),
      'gameEventList': instance.gameEventList,
      'rule': _$RuleTypeEnumMap[instance.rule],
    };

const _$GroceryTypeEnumMap = {
  GroceryType.goodWater: 'goodWater',
  GroceryType.badWater: 'badWater',
  GroceryType.goodFood: 'goodFood',
  GroceryType.badFood: 'badFood',
  GroceryType.goodAir: 'goodAir',
  GroceryType.badAir: 'badAir',
  GroceryType.goodClothes: 'goodClothes',
  GroceryType.badClothes: 'badClothes',
};

const _$RuleTypeEnumMap = {
  RuleType.noRule: 'noRule',
};
