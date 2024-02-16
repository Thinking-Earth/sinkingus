import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/core/network/firestore_base.dart';

part 'home_screen_viewmodel.g.dart';

class HomeScreenState {
  HomeScreenState();
}

@riverpod
class HomeScreenController extends _$HomeScreenController {
  @override
  HomeScreenState build() {
    return HomeScreenState();
  }

  void setState() {
    state = HomeScreenState();
  }

  void handlePressedBuildRoom() async {
    final newMatchId = FirebaseDatabase.instance.ref("lobby").push().key;
    await FirebaseDatabase.instance.ref("lobby/public/$newMatchId").set({
      "roomName": "test match",
      "playerCount": 1,
    });
    await FirebaseDatabase.instance.ref("game/$newMatchId").set({
      "roomName": "test room",
      "host": "my uid",
      "players": [
        {
          "name": "eunzee",
          "uid": "my uid",
          "role": "default",
          "position": [0, 0]
        }
      ],
      "day": 0,
      "item": [1, 0],
      "rule": "default rule",
    });
    // start game as a host
    print("create match: $newMatchId");
    AppRouter.pushNamed(Routes.gameMainScreenRoute);
  }

  void handlePressedSearchRoom() {
    AppRouter.pushNamed(Routes.gameMainScreenRoute);
  }
}
