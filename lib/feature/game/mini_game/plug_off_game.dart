import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class PlugOffGame extends FlameGame {
  @override
  FutureOr<void> onLoad() async {
    SpriteComponent background = SpriteComponent(
        sprite: await Sprite.load("minigame/pop up.jpg"),
        size: Vector2(455.3.w, 256.w));

    SpriteComponent plugBackground = SpriteComponent(
        sprite: await Sprite.load("minigame/plug/plug.png"),
        size: Vector2(455.3.w, 256.w));

    DragableSprite plug1 = DragableSprite(
        originalPosition: Vector2(133.3.w, 60.w),
        goal: (Vector2 position) {
          if (position.y > 81.6.w) return true;
          return false;
        },
        size: Vector2(26.6.w, 20.w),
        src: "minigame/plug/plug in 1.png",
        changedSrc: "minigame/plug/plug out 1.png");

    DragableSprite plug2 = DragableSprite(
        originalPosition: Vector2(133.3.w, 97.w),
        goal: (Vector2 position) {
          if (position.y > 114.w) return true;
          return false;
        },
        size: Vector2(26.6.w, 20.w),
        src: "minigame/plug/plug in 1-2.png",
        changedSrc: "minigame/plug/plug out 1-2.png");

    DragableSprite plug3 = DragableSprite(
        originalPosition: Vector2(198.w, 137.w),
        goal: (Vector2 position) {
          if (position.y < 135.w) return true;
          return false;
        },
        size: Vector2(24.w, 12.w),
        src: "minigame/plug/plug in 2.png",
        changedSrc: "minigame/plug/plug out 2.png");

    DragableSprite plug4 = DragableSprite(
        originalPosition: Vector2(225.w, 122.w),
        extraPosition: Vector2(27.w, -15.w),
        goal: (Vector2 position) {
          if (position.y < 120.w) return true;
          return false;
        },
        size: Vector2(24.w, 12.w),
        src: "minigame/plug/plug in 2.png",
        changedSrc: "minigame/plug/plug out 2.png");

    DragableSprite plug5 = DragableSprite(
        originalPosition: Vector2(252.w, 106.w),
        extraPosition: Vector2(54.w, -31.w),
        goal: (Vector2 position) {
          if (position.y < 105.w) return true;
          return false;
        },
        size: Vector2(24.w, 12.w),
        src: "minigame/plug/plug in 2.png",
        changedSrc: "minigame/plug/plug out 2.png");

    TextBoxComponent gameText = TextBoxComponent(
        text: "This is plug off game.",
        align: Anchor.center,
        anchor: Anchor.center,
        position: Vector2(227.65.w, 226.w),
        size: Vector2(362, 22.w),
        textRenderer: TextPaint(style: AppTypography.whitePixel),
        boxConfig: TextBoxConfig(timePerChar: 0.1, growingBox: true));

    ClickableSprite xBtn = ClickableSprite(
        position: Vector2(10.w, 13.w),
        size: Vector2.all(14.w),
        onClickEvent: (position, component) {
          bool result = plug1.isGoal &&
              plug2.isGoal &&
              plug3.isGoal &&
              plug4.isGoal &&
              plug5.isGoal;
          Navigator.of(AppRouter.navigatorKey.currentContext!).pop(result);
        },
        src: "minigame/xBtn.png");

    add(background);
    add(xBtn);
    add(plugBackground);
    addAll([plug2, plug1, plug3, plug4, plug5]);
    add(gameText);
    return super.onLoad();
  }
}
