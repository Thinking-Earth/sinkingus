import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/game/data/dataSource/match_data_source.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';

part 'match_domain.g.dart';

class MatchDomainState {
  MatchDomainState(
      {required this.matchId, required this.uid, required this.match});

  String matchId;
  String uid;
  Match match;
}

@Riverpod(keepAlive: true)
class MatchDomainController extends _$MatchDomainController {
  final MatchDataSource source = MatchDataSource();

  @override
  MatchDomainState build() {
    return MatchDomainState(
        matchId: "not in a match",
        uid: "my uid",
        match: Match(roomName: "", playerCount: 0));
  }

  void setState() {
    state = MatchDomainState(
        matchId: state.matchId, uid: state.uid, match: state.match);
  }

  void setMatchId(String matchId) {
    state.matchId = matchId;
    setState();
  }

  Future<void> buildMatch(
      {required String roomName, required bool isPrivate}) async {
    state.match = Match(
        roomName: roomName,
        playerCount: 1,
        players: ["my uid"],
        host: "my uid",
        day: 0,
        groceryList: {for (var item in GroceryType.values) item: false},
        rule: RuleType.noRule);
    await source.buildMatch(
        roomName: roomName,
        isPrivate: isPrivate ? "private" : "public",
        match: state.match);
  }

  void logOutFromMatch() {
    if (state.matchId != "not in a match") {
      source.logOutFromMatch(matchId: state.matchId, uid: state.uid);
    }
  }
}
