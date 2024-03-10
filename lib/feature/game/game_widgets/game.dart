import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/game_widgets/game_riverpod.dart';
import 'package:sinking_us/feature/game/game_widgets/game_ui.dart';
import 'package:sinking_us/feature/game/sprites/background.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';

class SinkingUsGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        RiverpodGameMixin,
        HasCollisionDetection {
  SinkingUsGame(this.matchId, this.uid, this.isHost);

  late MyPlayer player;
  late Background background;
  late List<PositionComponent> eventBtns =
      List<PositionComponent>.empty(growable: true);

  double dtSum = 0;
  String uid, matchId;
  bool isHost;
  int day = -1;

  late List<OtherPlayer> players = List<OtherPlayer>.empty(growable: true);

  late GameState state;
  late GameUI gameUI;

  double mapRatio = 1.8.w;

  @override
  FutureOr<void> onLoad() async {
    state = GameState();
    add(state);
    await FirebaseDatabase.instance
        .ref("game/$matchId/day")
        .once()
        .then((value) => day = value.snapshot.value as int);

    background = Background(mapRatio: mapRatio);

    final knobPaint = BasicPalette.white.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(100).paint();
    final joystick = JoystickComponent(
      knob: CircleComponent(radius: 15.w, paint: knobPaint),
      background: CircleComponent(radius: 50.w, paint: backgroundPaint),
      margin: EdgeInsets.only(left: 20.w, bottom: 20.h),
    );

    player = MyPlayer(uid, camera.viewport.size, joystick, background);

    gameUI = GameUI(camera.viewport.size, isHost);

    add(background);
    add(player);
    camera.viewport.add(joystick);

    //UI
    camera.viewport.add(gameUI);

    return super.onLoad();
  }

  @override
  FutureOr<void> onMount() async {
    if (day == 0) {
      FirebaseDatabase.instance
          .ref("game/$matchId/players")
          .onChildAdded
          .listen((event) {
        if (event.snapshot.exists) {
          if (event.snapshot.value.toString() != uid) {
            OtherPlayer newPlayer =
                OtherPlayer(event.snapshot.value.toString(), background.size);
            players.add(newPlayer);
            background.add(newPlayer);
          }
        }
      });

      FirebaseDatabase.instance
          .ref("game/$matchId/day")
          .onValue
          .listen((event) {
        if (event.snapshot.exists) {
          int newDay = (event.snapshot.value as int);
          if (day < newDay) {
            day = newDay;
            if (newDay == 1) {
              state.startGame();
              gameUI.startGame();
              background.addAll(eventBtns);
            } else if (newDay == 8) {
              state.gameEnd();
            } else if (newDay > 1) {
              if (state.currentEvent > -1) {
                Navigator.of(AppRouter.navigatorKey.currentContext!).pop(false);
              }
              state.nextDay();
              gameUI.nextDay(newDay);
            }
            player.nextDay();
          } else if (newDay > 0) {
            background.addAll(eventBtns);
          }
        } else {
          if (!isHost) {
            state.leaveMatch();
          }
        }
      });
    }

    setEventBtn();

    return super.onMount();
  }

  void deletePlayer(OtherPlayer otherPlayer) {
    players.remove(otherPlayer);
  }

  @override
  Color backgroundColor() {
    return const Color.fromRGBO(103, 103, 103, 1.0);
  }

  void setEventBtn() {
    PlugOffBtn plugOffBtn = PlugOffBtn(
        position: Vector2(1688, 638) * mapRatio,
        size: Vector2(12, 19) * mapRatio);
    WindPowerBtn windPowerBtn = WindPowerBtn(
        position: Vector2(1160.5, 1603) * mapRatio,
        size: Vector2(89, 146) * mapRatio);
    TrashBtn trashBtn = TrashBtn(
        position: Vector2(258, 1555) * mapRatio,
        size: Vector2(40, 28) * mapRatio);
    SunPowerBtn sunPowerBtn = SunPowerBtn(
        position: Vector2(1882, 264) * mapRatio,
        size: Vector2(30, 46) * mapRatio);
    WaterOffBtn waterOffBtn = WaterOffBtn(
        position: Vector2(493.5, 890.5) * mapRatio,
        size: Vector2(51, 33) * mapRatio);
    TreeBtn treeBtn = TreeBtn(
        position: Vector2(377.5, 457) * mapRatio,
        size: Vector2(41, 58) * mapRatio);
    BuyNecessityBtn buyNecessityBtn = BuyNecessityBtn(
        position: Vector2(1731.5, 1561.5) * mapRatio,
        size: Vector2(63, 35) * mapRatio);
    PolicyBtn nationalAssemblyBtn = PolicyBtn(
        position: Vector2(1120, 192.5) * mapRatio,
        size: Vector2(166, 101) * mapRatio);

    eventBtns.addAll([
      plugOffBtn,
      sunPowerBtn,
      windPowerBtn,
      trashBtn,
      treeBtn,
      waterOffBtn,
      buyNecessityBtn,
      nationalAssemblyBtn
    ]);
  }
}
