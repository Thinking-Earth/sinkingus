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
import 'package:sinking_us/feature/game/game_widgets/game_ui.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';

/// Director: 서버와 소통, 게임로직 관리

class SinkingUsGame extends FlameGame
    with HasKeyboardHandlerComponents, RiverpodGameMixin {
  SinkingUsGame(this.matchId, this.uid, this.isHost);

  late MyPlayer player;
  late SpriteComponent background;
  late List<PositionComponent> eventBtns =
      List<PositionComponent>.empty(growable: true);
  int currentEvent = -1;
  double dtSum = 0;

  late String matchId;
  int day = -1;
  int hp = 100;
  int natureScore = 100;
  int money = 100;
  bool isHost;
  late String uid;
  late List<OtherPlayer> players = List<OtherPlayer>.empty(growable: true);

  late GameUI gameUI;

  double mapRatio = 1.8.w;

  @override
  FutureOr<void> onLoad() async {
    await FirebaseDatabase.instance
        .ref("game/$matchId/day")
        .once()
        .then((value) => day = value.snapshot.value as int);
    return super.onLoad();
  }

  @override
  FutureOr<void> onMount() async {
    final knobPaint = BasicPalette.white.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(100).paint();
    final joystick = JoystickComponent(
      knob: CircleComponent(radius: 15.w, paint: knobPaint),
      background: CircleComponent(radius: 50.w, paint: backgroundPaint),
      margin: EdgeInsets.only(left: 20.w, bottom: 20.h),
    );

    Sprite backgroundSprite = await Sprite.load("map1.jpg");
    Sprite backgroundSprite2 = await Sprite.load("map2.png");
    background = SpriteComponent(sprite: backgroundSprite)
      ..size = backgroundSprite.originalSize * mapRatio
      ..anchor = Anchor.topCenter
      ..position =
          Vector2(0, backgroundSprite.originalSize.y * mapRatio * -0.5) +
              camera.viewport.virtualSize * 0.5;
    final background2 = SpriteComponent(sprite: backgroundSprite2)
      ..size = backgroundSprite.originalSize * mapRatio
      ..anchor = Anchor.topCenter
      ..position =
          Vector2(0, backgroundSprite.originalSize.y * mapRatio * -0.5) +
              camera.viewport.virtualSize * 0.5;

    // set my character
    player =
        MyPlayer(uid, camera.viewport.size, joystick, background, background2);

    setEventBtn();

    gameUI = GameUI(camera.viewport.size, isHost);

    add(background);
    add(player);
    add(background2);
    camera.viewport.add(joystick);

    //UI
    camera.viewport.add(gameUI);

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
            if (newDay == 1) {
              gameUI.startGame();
              background.addAll(eventBtns);
            } else if (newDay == 8) {
              gameEnd();
            } else if (newDay > 1) {
              if (currentEvent > -1) {
                Navigator.of(AppRouter.navigatorKey.currentContext!).pop(false);
              }
              gameUI.nextDay(newDay);
            }
            day = newDay;
            player.nextDay();
          } else if (newDay > 0) {
            background.addAll(eventBtns);
          }
        } else {
          gameEnd();
        }
      });
    }

    return super.onMount();
  }

  void deletePlayer(OtherPlayer otherPlayer) {
    players.remove(otherPlayer);
  }

  void gameEnd() async {
    Map<String, String> playersStatus = await FirebaseDatabase.instance
        .ref("game/$matchId/status")
        .get()
        .then((value) {
      return value.value as Map<String, String>;
    });
    String status = "undefined";
    if (day == 8) {
      switch (player.role) {
        case RoleType.worker:
          status = "win";
          break;
        case RoleType.business:
          if (money >= 3000) status = "win";
          break;
        case RoleType.politician:
          if (!playersStatus.values.contains("hp die")) status = "win";
          break;
        case RoleType.nature:
          if (natureScore >= 50) status = "win";
          break;
        case RoleType.undefined:
          break;
      }
    } else {
      if (hp == 0) {
        status = "hp die";
      } else if (natureScore == 0) {
        status = "nature die";
      }
    }
    gameUI.gameEnd(status);
  }

  @override
  void update(double dt) {
    if (hp == 0 || natureScore == 0) {
      gameEnd();
    }

    if (dtSum > 3) {
      hp -= 1;
      dtSum = 0;
    } else {
      dtSum += dt;
    }
    super.update(dt);
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
    NationalAssemblyBtn nationalAssemblyBtn = NationalAssemblyBtn(
        position: Vector2(1119, 192.5) * mapRatio,
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

  void setCurrentEvent(int currentEvent) {
    this.currentEvent = currentEvent;
  }
}
