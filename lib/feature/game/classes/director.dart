import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

/// Director: 서버와 소통, 게임로직 관리

class MyGame extends FlameGame with HasGameRef, HasKeyboardHandlerComponents {
  // TODO: 게임로직 짜기 (@전은지)
  // Director of the game
  @override
  FutureOr<void> onLoad() {
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
