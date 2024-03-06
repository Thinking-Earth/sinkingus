import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/data/dataSource/match_data_source.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/game/mini_game/buy_necessity_dialog.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'match_domain.g.dart';

class MatchDomainState {
  MatchDomainState(
      {required this.matchId,
      required this.match,
      required this.dayChangedTime,
      required this.hpdt,
      required this.moneydt,
      required this.natureScoredt});

  String matchId;
  Match match;
  int dayChangedTime;
  int hpdt;
  int natureScoredt;
  int moneydt;
}

@Riverpod(keepAlive: true)
class MatchDomainController extends _$MatchDomainController {
  final MatchDataSource source = MatchDataSource();

  @override
  MatchDomainState build() {
    return MatchDomainState(
        matchId: "not in a match",
        match: Match(roomName: "", playerCount: 0, isPrivate: true),
        dayChangedTime: 0,
        hpdt: 0,
        natureScoredt: 0,
        moneydt: 0);
  }

  void setState() {
    state = MatchDomainState(
        matchId: state.matchId,
        match: state.match,
        dayChangedTime: state.dayChangedTime,
        hpdt: state.hpdt,
        natureScoredt: state.natureScoredt,
        moneydt: state.moneydt);
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
        ShowDialogHelper.showSnackBar(content: "Too many people in the room");
      } else {
        state.match = response;
        state.matchId = matchId;
        setState();
        AppRouter.pushNamed(Routes.gameMainScreenRoute);
      }
    } else {
      ShowDialogHelper.showSnackBar(
          content:
              "The match doesn't exist. Maybe you should refresh the list.");
    }
  }

  Future<void> leaveMatch() async {
    if (state.matchId != "not in a match") {
      await source.leaveMatch(
          matchId: state.matchId,
          uid: ref.read(userDomainControllerProvider).userInfo!.uid,
          match: state.match);
      state.matchId = "not in a match";
      setState();
      AppRouter.popAndPushNamed(Routes.homeScreenRoute);
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
    state.dayChangedTime = DateTime.now().millisecondsSinceEpoch;
    state.match = state.match.copyWith(day: newDay);
    setState();
  }

  Future<void> hostStartGame() async {
    await source.deleteLobby(
        matchId: state.matchId, isPrivate: state.match.isPrivate!);
    source.hostStartGame(matchId: state.matchId);
    hostNextDay();
  }

  void hostNextDay() {
    source.updateDay(matchId: state.matchId);
  }

  Future<Map<String, String>> getPlayersStatus() async {
    return await source.getPlayersStatus(matchId: state.matchId);
  }

  void sendStatus({required String status}) {
    source.sendStatus(
        matchId: state.matchId,
        uid: ref.read(userDomainControllerProvider).userInfo!.uid,
        status: status);
  }
}
