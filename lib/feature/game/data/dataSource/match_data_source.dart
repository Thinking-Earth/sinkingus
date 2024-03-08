import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';
import 'package:sinking_us/feature/game/mini_game/buy_necessity_dialog.dart';
import 'package:sinking_us/feature/game/mini_game/select_policy_dialog.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';

class MatchDataSource {
  MatchDataSource();

  final db = FirebaseDatabase.instance;

  Future<bool> isLobbyExist(
      {required String matchId, required String isPrivate}) async {
    final matchData =
        await FirebaseDatabase.instance.ref("lobby/$isPrivate/$matchId").get();
    if (matchData.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<Match?> joinMatch(
      {required String matchId,
      required String isPrivate,
      required String uid,
      required String userName}) async {
    final gameRef = db.ref("game/$matchId");
    final data = await gameRef.get();
    final Map<dynamic, dynamic> castedData = Map<String, dynamic>.from(data.value as Map);
    Map<GroceryType, bool> groceryList = {
      GroceryType.goodClothes: castedData['groceryList']['goodClothes'],
      GroceryType.badClothes: castedData['groceryList']['badClothes'],
      GroceryType.goodFood: castedData['groceryList']['goodFood'],
      GroceryType.badFood: castedData['groceryList']['badFood'],
      GroceryType.goodAir: castedData['groceryList']['goodAir'],
      GroceryType.badAir: castedData['groceryList']['badAir'],
      GroceryType.goodWater: castedData['groceryList']['goodWater'],
      GroceryType.badWater: castedData['groceryList']['badWater']
    };
    final RuleType rule = castedData['rule'] != 'noRule' ? RuleType.getById(castedData['rule']) : RuleType.noRule;
    Match newMatch = Match(
      roomName: castedData['roomName'],
      rule: rule,
      day: castedData['day'],
      players: List<String>.from(castedData['players']),
      host: castedData['host'],
      natureScore: castedData['natureScore'],
      groceryList: groceryList,
      gameEventList: castedData['gameEventList'],
      isPrivate: castedData['isPrivate'],
      playerCount: 2
    );

    if (newMatch.playerCount < 6) {
      // TODO: 트랜잭션 재도전
      await db
          .ref("lobby/$isPrivate/$matchId")
          .update({"playerCount": ServerValue.increment(1)});

      await db.ref("players/$uid").set({
        "name": userName,
        "role": RoleType.undefined.code,
        "position": [0, 0]
      });

      List<String> players = newMatch.players!.toList(growable: true);
      players.add(uid);
      await gameRef.update(
          {"playerCount": newMatch.playerCount + 1, "players": players});
    } else {
      return null;
    }

    return newMatch;
  }

  Future<String> buildAndJoinMatch(
      {required String roomName,
      required String isPrivate,
      required Match match,
      required UserInfoModel userInfo}) async {
    final newMatchId = db.ref("lobby").push().key;
    await db.ref("lobby/$isPrivate/$newMatchId").set(Match(
            roomName: roomName,
            playerCount: 1,
            isPrivate: isPrivate == "private")
        .toJson());
    await db.ref("game/$newMatchId").set(match.toJson());
    await db.ref("players/${userInfo.uid}").set({
      "name": userInfo.nick,
      "role": RoleType.undefined.code,
      "position": [0, 0]
    });
    return newMatchId!;
  }

  Future<void> leaveMatch(
      {required String matchId,
      required String uid,
      required Match match}) async {
    DatabaseReference gameRef = db.ref("game/$matchId");
    final host = await gameRef.child("host").get();

    if (host.value == uid) {
      db
          .ref("lobby/${match.isPrivate! ? "private" : "public"}/$matchId")
          .remove();
      gameRef.remove();
    } else {
      if (match.day == 0) {
        await db
            .ref("lobby/${match.isPrivate! ? "private" : "public"}/$matchId")
            .get()
            .then((value) {
          if (value.exists) {
            db
                .ref(
                    "lobby/${match.isPrivate! ? "private" : "public"}/$matchId")
                .update({"playerCount": ServerValue.increment(-1)});
          }
        });
      }
      await gameRef.child("players").get().then((value) {
        if (value.exists) {
          final players = value.value as List<dynamic>;
          players.remove(uid);
          gameRef.update(
              {"playerCount": ServerValue.increment(-1), "players": players});
        }
      });
    }
    db.ref("players/$uid").remove();
  }

  Future<void> hostStartGame({required String matchId}) async {
    final uploadList =
        await db.ref("game/$matchId/players").get().then((value) {
      if (value.exists) return value.value as Iterable<dynamic>;
    });
    await db.ref("game/$matchId/status").set(
        {for (var element in uploadList!) element.toString(): "undefined"});
  }

  Future<void> updateDay({required String matchId}) async {
    await db.ref("game/$matchId").update({
      "day": ServerValue.increment(1),
      "gameEventList": List<int>.filled(6, 0)
    });
  }

  Future<Map<String, String>> getPlayersStatus(
      {required String matchId}) async {
    return await FirebaseDatabase.instance
        .ref("game/$matchId/status")
        .get()
        .then((value) {
      return Map<String, String>.from(value.value as Map);
    });
  }

  void sendStatus(
      {required String matchId,
      required String uid,
      required String status}) async {
    await FirebaseDatabase.instance
        .ref("game/$matchId/status")
        .update({uid: status});
  }

  Future<void> deleteLobby(
      {required String matchId, required bool isPrivate}) async {
    await db.ref("lobby/${isPrivate ? "private" : "public"}/$matchId").remove();
  }

  void setRule({required String matchId, required int ruleId}) {
    db.ref("game/$matchId/rule").set(ruleId);
  }
}
