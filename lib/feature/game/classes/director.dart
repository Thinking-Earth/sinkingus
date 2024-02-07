import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class MyGame extends FlameGame with HasGameRef, HasKeyboardHandlerComponents {
  // Director of the game
  @override
  FutureOr<void> onLoad() {
    print(size);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
