import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class TrashGame extends FlameGame {
  @override
  FutureOr<void> onMount() async {
    SpriteComponent background = SpriteComponent(
        sprite: await Sprite.load("minigame/pop up.jpg"),
        size: Vector2(455.3.w, 256.w));

    Sprite trashBackground1 = await Sprite.load("minigame/trash/trash.png");
    Sprite trashBackground2 = await Sprite.load("minigame/trash/trash2.png");
    final animation = SpriteAnimation.spriteList(
      [trashBackground1, trashBackground2],
      stepTime: 1,
    );

    SpriteAnimationComponent trashBackground = SpriteAnimationComponent(
        animation: animation, size: Vector2(455.3.w, 256.w));

    ClickableSprite bottle = ClickableSprite(
        position: Vector2(328, 110) / 3 * 1.w,
        size: Vector2(170, 171) / 3 * 1.w,
        onClickEvent: (position, component) {
          component.removeFromParent();
        },
        src: "minigame/trash/bottle.png");

    ClickableSprite bottleCap = ClickableSprite(
        position: Vector2(534, 132) / 3 * 1.w,
        size: Vector2(32, 27) / 3 * 1.w,
        onClickEvent: (position, component) {
          component.removeFromParent();
        },
        src: "minigame/trash/bottle cap.png");

    ClickableSprite can = ClickableSprite(
        position: Vector2(577, 179) / 3 * 1.w,
        size: Vector2(148, 105) / 3 * 1.w,
        onClickEvent: (position, component) {
          component.removeFromParent();
        },
        src: "minigame/trash/can.png");

    ClickableSprite straw = ClickableSprite(
        position: Vector2(468, 260) / 3 * 1.w,
        size: Vector2(148, 105) / 3 * 1.w,
        onClickEvent: (position, component) {
          component.removeFromParent();
        },
        src: "minigame/trash/straw.png");

    ClickableSprite plasticBag = ClickableSprite(
        position: Vector2(917, 127) / 3 * 1.w,
        size: Vector2(136, 134) / 3 * 1.w,
        onClickEvent: (position, component) {
          component.removeFromParent();
        },
        src: "minigame/trash/vinyl.png");

    TextBoxComponent gameText = TextBoxComponent(
        text: tr("trash_game"),
        align: Anchor.center,
        anchor: Anchor.center,
        position: Vector2(227.65.w, 226.w),
        size: Vector2(362, 22.w),
        textRenderer: TextPaint(style: AppTypography().whitePixel),
        boxConfig: const TextBoxConfig(timePerChar: 0.1, growingBox: true));

    ClickableSprite xBtn = ClickableSprite(
        position: Vector2(10.w, 13.w),
        size: Vector2.all(14.w),
        onClickEvent: (position, component) {
          bool result = bottle.isRemoved &&
              bottleCap.isRemoved &&
              can.isRemoved &&
              straw.isRemoved &&
              plasticBag.isRemoved;
          Navigator.of(AppRouter.navigatorKey.currentContext!).pop(result);
        },
        src: "minigame/xBtn.png");

    add(background);
    add(trashBackground);
    add(xBtn);
    add(gameText);
    addAll([bottle, bottleCap, can, straw, plasticBag]);

    return super.onMount();
  }
}
