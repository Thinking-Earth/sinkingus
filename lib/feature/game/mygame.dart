import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  @override
  void onLoad() {
    add(SpriteOne());
    super.onLoad();
  }
}

class SpriteOne extends PositionComponent {
  final Paint _paint = Paint()..color = Colors.red;

  @override
  void onLoad() {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(const Offset(150, 150), 25, _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}