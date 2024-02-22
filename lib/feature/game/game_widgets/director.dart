import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

/// Director: 서버와 소통, 게임로직 관리

class GameDirector extends FlameGame
    with HasGameRef, HasKeyboardHandlerComponents, RiverpodGameMixin {
  GameDirector();

  // TODO: 게임로직 짜기 (@전은지)
  // Director of the game
  @override
  FutureOr<void> onLoad() {
    overlays.add("leaveMenu");

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
