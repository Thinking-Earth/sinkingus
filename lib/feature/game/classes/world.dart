import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';

/// MyGame: initialize components

class MyWorld extends World {
  late SpriteComponent player;
  late SpriteComponent background;
  late CameraComponent camera;
  late List<RectangleComponent> rectangles =
      List<RectangleComponent>.empty(growable: true);

  late final JoystickComponent joystick;
  final double maxSpeed = -300;

  late Vector2 size;

  MyWorld(this.camera);

  @override
  FutureOr<void> onLoad() async {
    size = camera.viewport.virtualSize;

    // background
    Sprite backgroundSprite = await Sprite.load("map.png");
    background = SpriteComponent(sprite: backgroundSprite)
      ..size = backgroundSprite.originalSize * 3
      ..anchor = Anchor.center
      ..position = Vector2(size[0] * 0.5, size[1] * 0.5);

    setJoystick();
    setEventBtn();

    player = MyPlayer("worker", "temp name", size, joystick, background);

    // add components
    parent?.add(background);
    parent?.add(player);
    background.addAll(rectangles);
    camera.viewport.add(joystick);

    return super.onLoad();
  }

  void setJoystick() {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
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
