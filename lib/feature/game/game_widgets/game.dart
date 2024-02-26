import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';

/// Director: 서버와 소통, 게임로직 관리

class SinkingUsGame extends FlameGame
    with HasKeyboardHandlerComponents, RiverpodGameMixin {
  SinkingUsGame(this.matchId, this.uid);

  late SpriteComponent player;
  late SpriteComponent background;
  late List<RectangleComponent> rectangles =
      List<RectangleComponent>.empty(growable: true);

  late String matchId;
  late String uid;
  late List<OtherPlayer> players = List<OtherPlayer>.empty(growable: true);

  // TODO: 게임로직 짜기 (@전은지)
  // Director of the game
  @override
  FutureOr<void> onMount() async {
    overlays.add("leaveMenu");

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = JoystickComponent(
      knob: CircleComponent(radius: 15.w, paint: knobPaint),
      background: CircleComponent(radius: 50.w, paint: backgroundPaint),
      margin: EdgeInsets.only(left: 20.w, bottom: 20.h),
    );

    Sprite backgroundSprite = await Sprite.load("map1.jpg");
    Sprite backgroundSprite2 = await Sprite.load("map2.png");
    final background = SpriteComponent(sprite: backgroundSprite)
      ..size = backgroundSprite.originalSize * 3.w
      ..anchor = Anchor.topCenter
      ..position = Vector2(0, backgroundSprite.originalSize.y * -1.5.w) +
          camera.viewport.virtualSize * 0.5;
    final background2 = SpriteComponent(sprite: backgroundSprite2)
      ..size = backgroundSprite.originalSize * 3.w
      ..anchor = Anchor.topCenter
      ..position = Vector2(0, backgroundSprite.originalSize.y * -1.5.w) +
          camera.viewport.virtualSize * 0.5;

    // set my character
    player = MyPlayer(RoleType.undefined, camera.viewport.virtualSize, joystick,
        background, background2);

    FirebaseDatabase.instance
        .ref("game/$matchId/players")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.exists) {
        if (event.snapshot.value.toString() != uid) {
          OtherPlayer newPlayer = OtherPlayer(event.snapshot.value.toString(),
              backgroundSprite.originalSize * 3.w);
          players.add(newPlayer);
          background.add(newPlayer);
        }
      }
    });

    add(background);
    background.addAll(rectangles);
    add(player);
    add(background2);
    camera.viewport.add(joystick);

    return super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void setEventBtn() {
    // TODO: 위치 로컬에서 정해지게 되면 이부분 간단히 하기 (@전은지)
    BuyNecessityBtn buyNecessityBtn = BuyNecessityBtn(background.size * 0.5);
    PlugOffGameBtn plugOffGameBtn =
        PlugOffGameBtn(background.size * 0.5 + Vector2.all(300));
    SunPowerGameBtn sunPowerGameBtn =
        SunPowerGameBtn(background.size * 0.5 + Vector2.all(600));
    WindPowerGameBtn windPowerGameBtn =
        WindPowerGameBtn(background.size * 0.5 + Vector2.all(900));
    TrashGameBtn trashGameBtn =
        TrashGameBtn(background.size * 0.5 + Vector2.all(1200));
    TreeGameBtn treeGameBtn =
        TreeGameBtn(background.size * 0.5 + Vector2.all(1350));
    WaterOffGameBtn waterOffGameBtn =
        WaterOffGameBtn(background.size * 0.5 + Vector2.all(1500));
    NationalAssemblyBtn nationalAssemblyBtn =
        NationalAssemblyBtn(background.size * 0.5 + Vector2.all(1800));
    rectangles.addAll([
      buyNecessityBtn,
      nationalAssemblyBtn,
      plugOffGameBtn,
      sunPowerGameBtn,
      windPowerGameBtn,
      trashGameBtn,
      treeGameBtn,
      waterOffGameBtn
    ]);
  }
}
