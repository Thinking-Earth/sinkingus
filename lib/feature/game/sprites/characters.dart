import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/src/services/raw_keyboard.dart';

const CHARACTER_SIZE_X = 128.0;
const CHARACTER_SIZE_Y = 150.0;

class MyPlayer extends SpriteComponent
    with CollisionCallbacks, KeyboardHandler {
  int money = 0;
  String role;
  String name;
  JoystickComponent joystick;
  SpriteComponent background;

  double maxSpeed = -300.0;
  late final Vector2 screensize;

  MyPlayer(
      this.role, this.name, this.screensize, this.joystick, this.background)
      : super(
            size: Vector2.all(100.0),
            anchor: Anchor.center,
            position: screensize * 0.5);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("characters/" + role + "_idle_left.png");
    size = Vector2(CHARACTER_SIZE_X, CHARACTER_SIZE_Y);

    add(TextComponent(text: name, position: Vector2(0, -20)));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      background.position.add(joystick.relativeDelta * maxSpeed * dt);
      transform.scale = Vector2((joystick.relativeDelta.x > 0) ? -1 : 1, 1);
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      // TODO: 팝업 시 이동 못하게 막기 (@전은지)
      Vector2 moveDirection = Vector2.zero();
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) moveDirection.x += -10;
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) moveDirection.x += 10;
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW)) moveDirection.y += -10;
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
          keysPressed.contains(LogicalKeyboardKey.keyS)) moveDirection.y += 10;
      background.position.add(-moveDirection);
      transform.scale = Vector2(
          (moveDirection.x > 0) ? -1 : 1, 1); // TODO: sprite 바꾸기로 대체 (@전은지)

      if (keysPressed.contains(LogicalKeyboardKey.keyP)) print(position);
    }
    return super.onKeyEvent(event, keysPressed);
  }
}

class OtherPlayer extends SpriteComponent {
  String role;
  String name;

  OtherPlayer(this.role, this.name);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("characters/" + role + "_idle_left.png");
    size = Vector2(CHARACTER_SIZE_X, CHARACTER_SIZE_Y);

    add(TextComponent(text: name, position: Vector2(0, -20)));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // TODO: get position from server (@전은지)
  }
}
