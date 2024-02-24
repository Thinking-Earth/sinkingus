import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';

class GameMain extends ConsumerStatefulWidget {
  const GameMain({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameMainState();
}

class _GameMainState extends ConsumerState<GameMain> {
  late AppLifecycleListener listener;

  final GlobalKey<RiverpodAwareGameWidgetState> gameWidgetKey =
      GlobalKey<RiverpodAwareGameWidgetState>();

  @override
  Widget build(BuildContext context) {
    listener = AppLifecycleListener(
        onHide: ref.read(matchDomainControllerProvider.notifier).leaveMatch);

    SinkingUsGame game = SinkingUsGame(
        ref.read(matchDomainControllerProvider).matchId,
        ref.read(userDomainControllerProvider).userInfo!.uid);

    return RiverpodAwareGameWidget(
      key: gameWidgetKey,
      game: game,
      overlayBuilderMap: {
        "leaveMenu": (BuildContext context, game) {
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
  void deactivate() {
    listener.dispose();
    super.deactivate();
  }
}
