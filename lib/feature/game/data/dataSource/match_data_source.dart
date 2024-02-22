import 'package:firebase_database/firebase_database.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';

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
    Match newMatch = Match.fromJson(data.value as Map<String, dynamic>);

    if (newMatch.playerCount < 10) {
      await db
          .ref("lobby/$isPrivate/$matchId")
          .update({"playerCount": ServerValue.increment(1)});

      await db.ref("players/$uid").set({
        "name": userName,
        "role": "defalt",
        "position": [0, 0]
      });

      List<String> players = newMatch.players!.toList(growable: true);
      players.add(uid);
      await gameRef.update(
          {"playerCount": newMatch.playerCount + 1, "players": players});
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
      "role": "default",
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
      if (match.day! == 0) {
        db
            .ref("lobby/${match.isPrivate! ? "private" : "public"}/$matchId")
            .remove();
      }
      gameRef.remove();
    } else {
      if (match.day! == 0) {
        db
            .ref("lobby/${match.isPrivate! ? "private" : "public"}/$matchId")
            .update({"playerCount": ServerValue.increment(-1)});
      }
      final List<dynamic> players = await gameRef
          .child("players")
          .get()
          .then((value) => (value.value as List<dynamic>));
      players.remove(uid);
      await gameRef.update(
          {"playerCount": ServerValue.increment(-1), "players": players});
    }
    db.ref("players/$uid").remove();
  }
}
