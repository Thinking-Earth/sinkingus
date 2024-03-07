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

    String uid = ref.read(userDomainControllerProvider).userInfo!.uid;
    String host = ref.read(matchDomainControllerProvider).match.host!;

    SinkingUsGame game = SinkingUsGame(
        ref.read(matchDomainControllerProvider).matchId, uid, uid == host);

    return ClipRect(
      child: SafeArea(
        child: RiverpodAwareGameWidget(
          key: gameWidgetKey,
          game: game,
        ),
      ),
    );
  }

  @override
  void deactivate() {
    listener.dispose();
    super.deactivate();
  }
}
