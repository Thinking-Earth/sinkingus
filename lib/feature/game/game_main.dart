import 'package:firebase_database/firebase_database.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/game/game_widgets/director.dart';
import 'package:sinking_us/feature/game/game_widgets/world.dart';

class GameMain extends ConsumerStatefulWidget {
  const GameMain({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameMainState();
}

class _GameMainState extends ConsumerState<GameMain> {
  late String matchId;

  @override
  Widget build(BuildContext context) {
    GameDirector game = GameDirector();
    MyWorld myDirector = MyWorld(game.camera);
    game.world = myDirector;
    return GameWidget(game: game);
  }
}
