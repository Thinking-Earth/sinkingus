import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/chats/domain/chat_domain.dart';
import 'package:sinking_us/feature/game/chats/presentation/viewmodel/chat_viewmodel.dart';
import 'package:sinking_us/feature/game/data/dataSource/match_data_source.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/game/mini_game/buy_necessity_dialog.dart';
import 'package:sinking_us/feature/game/mini_game/select_policy_dialog.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'match_domain.g.dart';

class MatchDomainState {
  MatchDomainState(
      {required this.matchId,
      required this.match,
      required this.dayChangedTime,
      required this.hpdt,
      required this.money,
      required this.natureScoredt});

  String matchId;
  Match match;
  int dayChangedTime;
  int hpdt;
  int natureScoredt;
  int money;
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
        money: 100);
  }

  void setState() {
    state = MatchDomainState(
        matchId: state.matchId,
        match: state.match,
        dayChangedTime: state.dayChangedTime,
        hpdt: state.hpdt,
        natureScoredt: state.natureScoredt,
        money: state.money);
  }

  Future<Map<String, Match>> getMatchList() async {
    final data = await FirebaseDatabase.instance.ref("lobby/public").get();
    Map<String, Match> matchList = {};
    if (data.exists) {
      for (var element in data.children) {
        matchList[element.key!] =
            Match.fromJson(Map<String, dynamic>.from(element.value as Map));
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
        groceryList: {for (var item in GroceryType.values) item: -1},
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
        ShowDialogHelper.showSnackBar(
            content:
                "You are participating in another device or there are too many people."); //TODO
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

  void leaveMatch({bool isHostEnd = false}) {
    if (state.matchId != "not in a match") {
      if (!isHostEnd) {
        source.leaveMatch(
            matchId: state.matchId,
            uid: ref.read(userDomainControllerProvider).userInfo!.uid,
            match: state.match);
      }
      source.deletePlayer(ref.read(userDomainControllerProvider).userInfo!.uid);
      ref.read(chatDomainControllerProvider.notifier).outChatRoom(
          ref.read(openChatViewModelControllerProvider).chatID,
          nick: ref.read(userDomainControllerProvider).userInfo!.nick);
      state
        ..matchId = "not in a match"
        ..dayChangedTime = 0
        ..hpdt = 0
        ..natureScoredt = 0
        ..money = 100;
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
      leaveMatch(isHostEnd: false);
    }
  }

  void setNextDay(int newDay) {
    state.dayChangedTime = DateTime.now().millisecondsSinceEpoch;
    state.match = state.match.copyWith(day: newDay);
    setState();
  }

  Future<void> hostStartGame(String uid, List<String> players) async {
    await source.deleteLobby(
        matchId: state.matchId, isPrivate: state.match.isPrivate!);
    source.hostStartGame(matchId: state.matchId, uid: uid, players: players);
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

  bool setDt(int? hpdt, int? natureScoredt, int? moneydt) {
    if (state.money + (moneydt ?? 0) < 0) {
      return false;
    }
    state.money = state.money + (moneydt ?? 0);
    state.hpdt = hpdt ?? 0;
    state.natureScoredt = natureScoredt ?? 0;
    setState();
    state.hpdt = 0;
    state.natureScoredt = 0;
    return true;
  }

  void setRule(int ruleId) {
    source.setRule(matchId: state.matchId, ruleId: ruleId);
  }

  void setStoreActive(GroceryType type) {
    source.setStoreActive(matchId: state.matchId, type: type);
  }

  Future<Map<GroceryType, int>> getGroceryList() async {
    return await source.getGroceryList(matchId: state.matchId);
  }

  Future<RoleType> getRole(String uid) async {
    return await source
        .getRole(uid: uid)
        .then((value) => RoleType.getByCode(value));
  }

  void buy(int price) {
    source.buy(matchId: state.matchId, price: price);
  }
}
