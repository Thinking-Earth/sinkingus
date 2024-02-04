import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'package:sinking_us/feature/game/mygame.dart';

class GameMain extends ConsumerStatefulWidget{
  const GameMain({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameMainState();
}

class _GameMainState extends ConsumerState<GameMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: GameWidget(
          game: MyGame(),
        ),
      ),
    );
  }
}