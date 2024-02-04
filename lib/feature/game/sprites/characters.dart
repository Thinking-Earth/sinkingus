import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Player extends SpriteComponent with HasGameRef, CollisionCallbacks {
  int money = 0;
  String role;

  double maxSpeed = 300.0;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();

  JoystickComponent joystick;

  Player(this.role, this.joystick)
      : super(size: Vector2.all(100.0), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(role + ".png");
    this.size = Vector2(128.0, 128.0);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * maxSpeed * dt);
      scale = Vector2(joystick.relativeDelta.x > 0 ? -1 : 1, 1.0);
    }
  }
}
