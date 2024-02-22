import 'package:firebase_database/firebase_database.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';

class MatchDataSource {
  MatchDataSource();

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
    final gameRef = FirebaseDatabase.instance.ref("game/$matchId");
    final data = await gameRef.get();
    Match newMatch = Match.fromJson(data.value as Map<String, dynamic>);

    if (newMatch.playerCount < 10) {
      await FirebaseDatabase.instance
          .ref("lobby/$isPrivate/$matchId")
          .update({"playerCount": ServerValue.increment(1)});

      await FirebaseDatabase.instance.ref("players/$uid").set({
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

  Future<void> buildAndJoinMatch(
      {required String roomName,
      required String isPrivate,
      required Match match}) async {
    final newMatchId = FirebaseDatabase.instance.ref("lobby").push().key;
    await FirebaseDatabase.instance
        .ref("lobby/$isPrivate/$newMatchId")
        .set(Match(roomName: roomName, playerCount: 1).toJson());
    await FirebaseDatabase.instance.ref("game/$newMatchId").set(match.toJson());
  }

  Future<void> logOutFromMatch(
      {required String matchId, required String uid}) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref("game/$matchId");
    final data = await dbRef.child("playerCount").get();
    final host = await dbRef.child("host").get();
    if (host.value == uid) {
      dbRef.remove();
    } else {
      int playerCount = data.value as int;
      dbRef.child("players/$uid").remove();
      dbRef.child("playerCount").set(playerCount - 1);
    }
  }
}
