import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/data/dataSource/match_data_source.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';

part 'match_domain.g.dart';

class MatchDomainState {
  MatchDomainState({required this.matchId, required this.match});

  String matchId;
  Match match;
}

@Riverpod(keepAlive: true)
class MatchDomainController extends _$MatchDomainController {
  final MatchDataSource source = MatchDataSource();

  @override
  MatchDomainState build() {
    return MatchDomainState(
        matchId: "not in a match",
        match: Match(roomName: "", playerCount: 0, isPrivate: true));
  }

  void setState() {
    state = MatchDomainState(matchId: state.matchId, match: state.match);
  }

  Future<Map<String, Match>> getMatchList() async {
    final data = await FirebaseDatabase.instance.ref("lobby/public").get();
    Map<String, Match> matchList = {};
    if (data.exists) {
      for (var element in data.children) {
        matchList[element.key!] =
            Match.fromJson(element.value as Map<String, dynamic>);
      }
    }
    return matchList;
  }

  Future<void> buildAndJoinMatch(
      {required String roomName, required String isPrivate}) async {
    String uid = ref.read(userDomainControllerProvider).userInfo!.uid;
    state.match = Match(
        roomName: roomName,
        playerCount: 1,
        isPrivate: isPrivate == "private",
        players: [uid],
        host: uid,
        day: 0,
        natureScore: 100,
        groceryList: {for (var item in GroceryType.values) item: false},
        rule: RuleType.noRule);
    state.matchId = await source.buildAndJoinMatch(
        roomName: roomName,
        isPrivate: isPrivate,
        match: state.match,
        userInfo: ref.read(userDomainControllerProvider).userInfo!);
    setState();
    AppRouter.pushNamed(Routes.gameMainScreenRoute);
  }

  Future<void> joinMatch(
      {required String matchId, required String isPrivate}) async {
    bool isMatchExist =
        await source.isLobbyExist(matchId: matchId, isPrivate: isPrivate);
    if (isMatchExist) {
      final response = await source.joinMatch(
          matchId: matchId,
          isPrivate: isPrivate,
          uid: ref.read(userDomainControllerProvider).userInfo!.uid,
          userName: ref.read(userDomainControllerProvider).userInfo!.nick);
      if (response == null) {
        print("Too many people.");
        // TODO: dialog로 안내
      } else {
        state.match = response;
        state.matchId = matchId;
        setState();
        AppRouter.pushNamed(Routes.gameMainScreenRoute);
      }
    } else {
      print("The match doesn't exist. Maybe you should refresh the list.");
      //TODO: dialog로 안내
    }
  }

  Future<void> leaveMatch() async {
    if (state.matchId != "not in a match") {
      print("leave: triggered");
      await source.leaveMatch(
          matchId: state.matchId,
          uid: ref.read(userDomainControllerProvider).userInfo!.uid,
          match: state.match);
      state.matchId = "not in a match";
      setState();
      AppRouter.pushNamed(Routes.homeScreenRoute);
    } else {
      print("not in a match");
    }
  }

  bool isHost() {
    return state.match.host ==
        ref.read(userDomainControllerProvider).userInfo!.uid;
  }

  void checkNotInMatch() {
    if (state.matchId != "not in a match") {
      leaveMatch();
    }
  }

  void setNextDay(int newDay) {
    state.match = state.match.copyWith(day: newDay);
    setState();
  }

  void nextDay() {
    if (state.match.day! < 7) {
      source.updateDay(matchId: state.matchId);
      setNextDay(state.match.day! + 1);
    } else {
      // game end
    }
  }
}
