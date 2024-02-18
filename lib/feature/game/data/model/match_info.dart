import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_info.freezed.dart';
part 'match_info.g.dart';

@JsonEnum(valueField: 'code')
enum GroceryType {
  goodWater("goodWater"),
  badWater("badWater"),
  goodFood("goodFood"),
  badFood("badFood"),
  goodAir("goodAir"),
  badAir("badAir"),
  goodClothes("goodClothes"),
  badClothes("badClothes");

  const GroceryType(this.code);
  final String code;
}

@JsonEnum(valueField: 'code')
enum RuleType {
  noRule("noRule");

  const RuleType(this.code);
  final String code;
}

@freezed
class Match with _$Match {
  factory Match({
    required String roomName,
    required int playerCount,
    List<String>? players,
    String? host,
    int? day,
    Map<GroceryType, bool>? groceryList,
    RuleType? rule,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}
