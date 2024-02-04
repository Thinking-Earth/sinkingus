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

  late final JoystickComponent joystick;

  @override
  FutureOr<void> onLoad() async {
    background = SpriteComponent(sprite: await loadSprite("map.png"))
      ..size = (size[0] > size[1])
          ? Vector2(size[1] * 3085 / 2358, size[1])
          : Vector2(size[0], size[0] * 2358 / 3085)
      ..anchor = Anchor.topLeft;
    add(background);

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    player = Player("people", joystick);
    add(player);
    camera.viewport.add(joystick);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
