import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Player extends SpriteComponent with HasGameRef, CollisionCallbacks {
  int money = 0;
  String role;

  double maxSpeed = 300.0;
  late final Vector2 screensize;

  Player(this.role, this.screensize)
      : super(
            size: Vector2.all(100.0),
            anchor: Anchor.center,
            position: Vector2(screensize.x * 0.5, screensize.y * 0.5));

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
  }
}
