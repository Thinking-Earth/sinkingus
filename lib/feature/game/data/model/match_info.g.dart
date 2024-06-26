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
      natureScore: json['natureScore'] as int?,
      groceryList: (json['groceryList'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$GroceryTypeEnumMap, k), e as int),
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
      'natureScore': instance.natureScore,
      'groceryList': instance.groceryList
          ?.map((k, e) => MapEntry(_$GroceryTypeEnumMap[k]!, e)),
      'gameEventList': instance.gameEventList,
      'rule': _$RuleTypeEnumMap[instance.rule],
    };

const _$GroceryTypeEnumMap = {
  GroceryType.goodClothes: 'goodClothes',
  GroceryType.badClothes: 'badClothes',
  GroceryType.goodFood: 'goodFood',
  GroceryType.badFood: 'badFood',
  GroceryType.goodAir: 'goodAir',
  GroceryType.badAir: 'badAir',
  GroceryType.goodWater: 'goodWater',
  GroceryType.badWater: 'badWater',
};

const _$RuleTypeEnumMap = {
  RuleType.noRule: 0,
  RuleType.greenGrowthStrategy: 1,
  RuleType.greenDeal: 2,
  RuleType.parisAgreement: 3,
  RuleType.carbonNeutrality: 4,
};
