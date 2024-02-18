import 'package:firebase_database/firebase_database.dart';
import 'package:sinking_us/feature/game/data/model/match_info.dart';

class MatchDataSource {
  MatchDataSource();

  Future<void> buildMatch(
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
    print("${data.value} ${host.value}");
    if (data.value as int == 1 || host.value == uid) {
      dbRef.remove();
    } else {
      int playerCount = data.value as int;
      dbRef.child("players/$uid").remove();
      dbRef.child("playerCount").set(playerCount - 1);
    }
  }
}
