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
      ..size = backgroundSprite.originalSize * 2.4.w
      ..anchor = Anchor.topCenter
      ..position = Vector2(0, backgroundSprite.originalSize.y * -1.2.w) +
          camera.viewport.virtualSize * 0.5;
    final background2 = SpriteComponent(sprite: backgroundSprite2)
      ..size = backgroundSprite.originalSize * 2.4.w
      ..anchor = Anchor.topCenter
      ..position = Vector2(0, backgroundSprite.originalSize.y * -1.2.w) +
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
    PlugOffBtn plugOffBtn = PlugOffBtn(vertices: [
      Vector2(-1, -1),
      Vector2(-1, 1),
      Vector2(1, 1),
      Vector2(1, -1)
    ], position: Vector2(4051.2.w, 1531.2.w), size: Vector2(28.8.w, 45.6.w));
    eventBtns.add(plugOffBtn);
  }
}
