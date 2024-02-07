import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/classes/director.dart';
import 'package:sinking_us/feature/game/classes/world.dart';

class GameMain extends StatelessWidget {
  const GameMain({super.key});

  @override
  Widget build(BuildContext context) {
    MyGame game = MyGame();
    MyWorld myDirector = MyWorld(game.camera);
    game.world = myDirector;

    return GameWidget(game: game);
  }
}
