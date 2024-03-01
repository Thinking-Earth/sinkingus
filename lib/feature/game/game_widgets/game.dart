import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/game_widgets/game_ui.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';

/// Director: 서버와 소통, 게임로직 관리

class SinkingUsGame extends FlameGame
    with HasKeyboardHandlerComponents, RiverpodGameMixin {
  SinkingUsGame(this.matchId, this.uid, this.isHost);

  late SpriteComponent player;
  late SpriteComponent background;
  late List<PositionComponent> eventBtns =
      List<PositionComponent>.empty(growable: true);

  late String matchId;
  bool isHost;
  late String uid;
  late List<OtherPlayer> players = List<OtherPlayer>.empty(growable: true);

  late PositionComponent gameUI;

  double mapRatio = 2.4.w;

  // TODO: 게임로직 짜기 (@전은지)
  // Director of the game
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
    player = MyPlayer(RoleType.undefined, camera.viewport.size, joystick,
        background, background2);

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

    setEventBtn();

    gameUI = GameUI(camera.viewport.size, isHost);

    add(background);
    background.addAll(eventBtns);
    add(player);
    add(background2);
    camera.viewport.add(joystick);

    //UI
    camera.viewport.add(gameUI);

    return super.onMount();
  }

  @override
  Color backgroundColor() {
    return const Color.fromRGBO(103, 103, 103, 1.0);
  }

  void setEventBtn() {
    // TODO: vertices 간단히
    PlugOffBtn plugOffBtn = PlugOffBtn(
        vertices: [
          Vector2(-1, -1),
          Vector2(-1, 1),
          Vector2(1, 1),
          Vector2(1, -1)
        ],
        position: Vector2(1688, 638) * mapRatio,
        size: Vector2(12, 19) * mapRatio);
    WindPowerBtn windPowerBtn = WindPowerBtn(
        vertices: [
          Vector2(0.258, -0.369),
          Vector2(0.258, -0.493),
          Vector2(1, -1),
          Vector2(0.393, -0.328),
          Vector2(0.483, -0.246),
          Vector2(0.910, 0.287),
          Vector2(0.865, 0.315),
          Vector2(0.258, -0.137),
          Vector2(0.236, -0.26),
          Vector2(0.169, -0.26),
          Vector2(0.191, 0.973),
          Vector2(-0.101, 0.973),
          Vector2(0.0112, -0.205),
          Vector2(-1.0, -0.26),
          Vector2(0.101, -0.438),
        ],
        position: Vector2(1160.5, 1603) * mapRatio,
        size: Vector2(89, 146) * mapRatio);
    TrashBtn trashBtn = TrashBtn(
        vertices: [
          Vector2(-0.02, -0.5),
          Vector2(0.5, -1.07),
          Vector2(1.05, -0.214),
          Vector2(1.0, 0.18),
          Vector2(0.25, 0.929),
          Vector2(0.0, 0.929),
          Vector2(-0.9, 0.55),
          Vector2(-1.0, 0.0714),
          Vector2(-0.75, -0.643),
          Vector2(-0.4, -0.643),
        ],
        position: Vector2(258, 1555) * mapRatio,
        size: Vector2(40, 28) * mapRatio);
    SunPowerBtn sunPowerBtn = SunPowerBtn(
        vertices: [
          Vector2(-1, -1),
          Vector2(-1, 1),
          Vector2(1, 1),
          Vector2(1, -1)
        ],
        position: Vector2(1000, 1555) * mapRatio,
        size: Vector2(40, 28) * mapRatio);
    WaterOffBtn waterOffBtn = WaterOffBtn(
        vertices: [
          Vector2(-0.882, -1.0),
          Vector2(0.843, -1.0),
          Vector2(1.0, -0.515),
          Vector2(1.0, 0.212),
          Vector2(0.765, 0.697),
          Vector2(0.333, 1.0),
          Vector2(-0.373, 1.0),
          Vector2(-0.765, 0.636),
          Vector2(-1.0, 0.212),
          Vector2(-1.0, -0.515),
        ],
        position: Vector2(493.5, 890.5) * mapRatio,
        size: Vector2(51, 33) * mapRatio);
    TreeBtn treeBtn = TreeBtn(
        vertices: [
          Vector2(-1, -1),
          Vector2(-1, 1),
          Vector2(1, 1),
          Vector2(1, -1)
        ],
        position: Vector2(320, 325) * mapRatio,
        size: Vector2(49, 40) * mapRatio);
    eventBtns.addAll([
      plugOffBtn,
      windPowerBtn,
      trashBtn,
      sunPowerBtn,
      waterOffBtn,
      treeBtn
    ]);
  }
}
