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
  late final AppLifecycleListener listener;

  @override
  Widget build(BuildContext context) {
    listener = AppLifecycleListener(
        onHide: ref.read(matchDomainControllerProvider.notifier).leaveMatch);

    GameDirector game = GameDirector();
    MyWorld myDirector = MyWorld(game.camera);
    game.world = myDirector;
    return GameWidget(
      game: game,
      overlayBuilderMap: {
        "leaveMenu": (BuildContext context, GameDirector game) {
          return TextButton(
              onPressed:
                  ref.read(matchDomainControllerProvider.notifier).leaveMatch,
              child: Container(
                color: Colors.white,
                child: const Text("leave game"),
              ));
        }
      },
    );
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }
}
