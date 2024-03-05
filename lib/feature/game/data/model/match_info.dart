import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_info.freezed.dart';
part 'match_info.g.dart';

@JsonEnum(valueField: 'code')
enum GroceryType {
  goodWater(0, "goodWater", 120, 10),
  badWater(1, "badWater", 60, 20),
  goodFood(2, "goodFood", 120, 10),
  badFood(3, "badFood", 60, 20),
  goodAir(4, "goodAir", 120, 10),
  badAir(5, "badAir", 60, 20),
  goodClothes(6, "goodClothes", 120, 10),
  badClothes(7, "badClothes", 60, 20);

  const GroceryType(this.id, this.code, this.price, this.destroyScore);
  final String code;
  final int id;
  final int price;
  final int destroyScore;
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
    bool? isPrivate,
    List<String>? players,
    String? host,
    int? day,
    int? natureScore,
    Map<GroceryType, bool>? groceryList,
    List<int>? gameEventList,
    RuleType? rule,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}
