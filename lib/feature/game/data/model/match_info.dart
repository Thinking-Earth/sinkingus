import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sinking_us/feature/game/mini_game/buy_necessity_dialog.dart';

part 'match_info.freezed.dart';
part 'match_info.g.dart';

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
