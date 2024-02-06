import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';

class GameMain extends StatelessWidget {
  const GameMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(),
    );
  }
}

class MyGame extends FlameGame {
  late SpriteComponent player;
  late SpriteComponent background;
  late RectangleComponent rectangle;

  late final JoystickComponent joystick;
  double maxSpeed = -300;

  @override
  FutureOr<void> onLoad() async {
    // intialize local components
    //addLocalComponents();

    // background
    Sprite backgroundSprite = await loadSprite("map.png");
    background = SpriteComponent(sprite: backgroundSprite)
      ..size = backgroundSprite.originalSize * 3
      ..anchor = Anchor.center
      ..position = Vector2(size[0] * 0.5, size[1] * 0.5);

    setJoystick();
    setBtnCollision(background);

    player = MyPlayer("worker", size, joystick, background);

    // add components
    add(background);
    add(player);
    background.add(rectangle);
    camera.viewport.add(joystick);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
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

  void setBtnCollision(background) {
    final paint = BasicPalette.red.paint()..style = PaintingStyle.stroke;
    rectangle = RectangleComponent(
      size: Vector2(300.0, 200.0),
      anchor: Anchor.topLeft,
      position: Vector2(0, 0),
      paint: paint,
    );
  }
}
