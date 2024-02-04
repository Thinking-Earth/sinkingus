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

  double maxSpeed = -300;

  @override
  FutureOr<void> onLoad() async {
    Sprite backgroundSprite = await loadSprite("map.png");
    background = SpriteComponent(sprite: backgroundSprite)
      ..size = backgroundSprite.originalSize * 3
      ..anchor = Anchor.center
      ..position = Vector2(size[0] * 0.5, size[1] * 0.5);
    add(background);

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    player = Player("people", size);
    add(player);
    camera.follow(player);
    camera.viewport.add(joystick);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!joystick.delta.isZero()) {
      background.position.add(joystick.relativeDelta * maxSpeed * dt);
      player.transform.scale =
          Vector2((joystick.relativeDelta.x > 0) ? -1 : 1, 1);
    }
  }
}
