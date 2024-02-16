import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_info.freezed.dart';
part 'match_info.g.dart';

@freezed
class Match with _$Match {
  factory Match({
    required String roomName,
    required int playerCount,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}
