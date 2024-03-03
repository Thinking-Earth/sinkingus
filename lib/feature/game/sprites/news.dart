import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class News extends FlameGame {
  late Timer timer;
  late String text;

  @override
  FutureOr<void> onLoad() {
    timer = Timer(8,
        onTick: () =>
            Navigator.of(AppRouter.navigatorKey.currentContext!).pop(true));
    TextBoxComponent newsText = TextBoxComponent(
        text: text,
        textRenderer: TextPaint(style: AppTypography.whitePixel),
        boxConfig: TextBoxConfig(timePerChar: 0.1, growingBox: true),
        position: size * 0.5,
        anchor: Anchor.center);
    add(newsText);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    timer = Timer(8,
        onTick: () =>
            Navigator.of(AppRouter.navigatorKey.currentContext!).pop(true));
    TextBoxComponent newsText = TextBoxComponent(
        text: text,
        textRenderer: TextPaint(style: AppTypography.whitePixel),
        boxConfig: TextBoxConfig(timePerChar: 0.1, growingBox: true),
        position: size * 0.5,
        anchor: Anchor.center);
    add(newsText);
    super.onGameResize(size);
  }
}
