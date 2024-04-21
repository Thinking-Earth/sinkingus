import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class News extends FlameGame {
  late Timer timer;
  String? text;
  GameEventType type = GameEventType.news;
  late TextBoxComponent dayText, newsText;

  SinkingUsGame game;

  News({required this.game});

  @override
  FutureOr<void> onLoad() async {
    final background =
        SpriteComponent(sprite: await Sprite.load("etc/news.png"), size: size);
    add(background);

    return super.onLoad();
  }

  @override
  void onMount() {
    game.state.currentEvent = type.id;
    timer = Timer(8, onTick: () {
      remove(dayText);
      remove(newsText);
      Navigator.of(AppRouter.navigatorKey.currentContext!).pop(true);
    });
    timer.start();

    dayText = TextBoxComponent(
        text: "DAY ${game.day}",
        textRenderer: TextPaint(style: AppTypography().blackPixel),
        boxConfig: const TextBoxConfig(timePerChar: 0.1, growingBox: true),
        position: Vector2(743.w, 262.w) / 3,
        anchor: Anchor.center);

    newsText = TextBoxComponent(
        text: text ?? "",
        anchor: Anchor.center,
        textRenderer: TextPaint(style: AppTypography().blackPixel),
        position: Vector2(726.w, 445.w) / 3,
        size: Vector2(975.w, 303.w) / 3);

    add(dayText);
    add(newsText);

    super.onMount();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);
  }
}
