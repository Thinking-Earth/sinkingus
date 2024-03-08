import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class News extends FlameGame {
  late Timer timer;
  late String? text;
  SinkingUsGame game;
  GameEventType type = GameEventType.news;
  late TextBoxComponent newsText;

  News(this.game);

  @override
  void onMount() {
    game.state.currentEvent = type.id;
    timer = Timer(8, onTick: () {
      remove(newsText);
      Navigator.of(AppRouter.navigatorKey.currentContext!).pop(true);
    });
    timer.start();
    newsText = TextBoxComponent(
        text: text ?? "",
        textRenderer: TextPaint(style: AppTypography.whitePixel),
        boxConfig: TextBoxConfig(timePerChar: 0.1, growingBox: true),
        position: size * 0.5,
        anchor: Anchor.center);
    add(newsText);
    super.onMount();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);
  }
}
