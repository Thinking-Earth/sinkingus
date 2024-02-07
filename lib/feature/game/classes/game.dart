import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';

/**
 * MyGame: initialize components
 * 
 */

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
    // intialize local components
    //addLocalComponents();
    size = camera.viewport.virtualSize;
    print(size);

    // background
    Sprite backgroundSprite = await Sprite.load("map.png");
    background = SpriteComponent(sprite: backgroundSprite)
      ..size = backgroundSprite.originalSize * 3
      ..anchor = Anchor.center
      ..position = Vector2(size[0] * 0.5, size[1] * 0.5);

    setJoystick();
    setSpriteBtn();

    player = MyPlayer("worker", size, joystick, background);

    // add components
    parent?.add(background);
    parent?.add(player);
    background.addAll(rectangles);
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

  void setSpriteBtn() {
    List<String> spriteNames = [
      "buy necessity",
      "national assembly",
      "plug off",
      "sun power",
      "wind power",
      "trash",
      "tree",
      "water off"
    ];
    for (double i = 0; i < 8; i++) {
      final paint = BasicPalette.red.paint()..style = PaintingStyle.stroke;
      rectangles.add(RectangleComponent(
        size: Vector2(300.0, 200.0),
        anchor: Anchor.center,
        position: background.size * 0.5 + Vector2.all(i + 1) * 300,
        paint: paint,
      ));
      rectangles[i.toInt()].add(TextComponent(text: spriteNames[i.toInt()]));
    }
  }
}
