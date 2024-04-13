import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class WindPowerGame extends FlameGame {
  @override
  FutureOr<void> onMount() async {
    SpriteComponent background = SpriteComponent(
        sprite: await Sprite.load("minigame/pop up.jpg"),
        size: Vector2(455.3.w, 256.w));

    TextBoxComponent gameText = TextBoxComponent(
        text: tr("wind_power"),
        align: Anchor.center,
        anchor: Anchor.center,
        position: Vector2(227.65.w, 226.w),
        size: Vector2(362, 22.w),
        textRenderer: TextPaint(style: AppTypography.whitePixel),
        boxConfig: const TextBoxConfig(timePerChar: 0.1, growingBox: true));

    SpriteComponent windBody1 = SpriteComponent(
        sprite: await Sprite.load("minigame/wind/wind body.png"),
        position: Vector2(12.w, 3.w),
        size: Vector2(455.3.w, 256.w));

    ClickableSprite windWing1 = ClickableSprite(
        position: Vector2(133.w, 100.w),
        extraPosition: Vector2(12.w, 3.w) + Vector2.all(76.w) * 0.5,
        size: Vector2.all(76.w),
        onClickEvent: (position, component) {
          if (position.x > component.x && component.angle < 15) {
            component.angle += 15;
          } else if (position.x < component.x && component.angle > -15) {
            component.angle -= 15;
          }
        },
        src: "minigame/wind/wind wing.png")
      ..anchor = Anchor.center;

    SpriteComponent windBody2 = SpriteComponent(
        sprite: await Sprite.load("minigame/wind/wind body.png"),
        position: Vector2(100.w, 3.w),
        size: Vector2(455.3.w, 256.w));

    ClickableSprite windWing2 = ClickableSprite(
        position: Vector2(221.w, 100.w),
        extraPosition: Vector2(100.w, 3.w) + Vector2.all(76.w) * 0.5,
        size: Vector2.all(76.w),
        onClickEvent: (position, component) {
          if (position.x > component.x && component.angle < 15) {
            component.angle += 15;
          } else if (position.x < component.x && component.angle > -15) {
            component.angle -= 15;
          }
        },
        src: "minigame/wind/wind wing.png")
      ..anchor = Anchor.center;

    SpriteComponent windBody3 = SpriteComponent(
        sprite: await Sprite.load("minigame/wind/wind body.png"),
        position: Vector2(188.w, 3.w),
        size: Vector2(455.3.w, 256.w));

    ClickableSprite windWing3 = ClickableSprite(
        position: Vector2(309.w, 100.w),
        extraPosition: Vector2(188.w, 3.w) + Vector2.all(76.w) * 0.5,
        size: Vector2.all(76.w),
        onClickEvent: (position, component) {
          if (position.x > component.x && component.angle < 15) {
            component.angle += 15;
          } else if (position.x < component.x && component.angle > -15) {
            component.angle -= 15;
          }
        },
        src: "minigame/wind/wind wing.png")
      ..anchor = Anchor.center;

    SpriteComponent windBackground = SpriteComponent(
        sprite: await Sprite.load("minigame/wind/beach wind.png"),
        size: Vector2(455.3.w, 256.w));

    ClickableSprite xBtn = ClickableSprite(
        position: Vector2(10.w, 13.w),
        size: Vector2.all(14.w),
        onClickEvent: (position, sprite) {
          bool result = windWing1.angle == 15 &&
              windWing2.angle == 15 &&
              windWing3.angle == -15;
          Navigator.of(AppRouter.navigatorKey.currentContext!).pop(result);
        },
        src: "minigame/xBtn.png");

    add(background);
    add(gameText);
    add(xBtn);

    add(windBackground);
    addAll([windWing1, windWing2, windWing3, windBody1, windBody2, windBody3]);

    return super.onMount();
  }
}
