import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class WaterOffGame extends FlameGame {
  @override
  FutureOr<void> onMount() async {
    SpriteComponent background = SpriteComponent(
        sprite: await Sprite.load("minigame/pop up.jpg"),
        size: Vector2(455.3.w, 256.w));

    SpriteComponent toiletBackground = SpriteComponent(
        sprite: await Sprite.load("minigame/water/toilet.jpg"),
        size: Vector2(455.3.w, 256.w));

    SpriteComponent water1 = SpriteComponent(
        sprite: await Sprite.load("minigame/water/water.png"),
        size: Vector2(455.3.w, 256.w),
        position: Vector2(188.w - 12.w, 49.w) / 3);

    PositionComponent waterComponent1 = PositionComponent(
        anchor: Anchor.center,
        position: Vector2(455.3.w, 256.w) / 2 - Vector2(188.w, 49.w) / 3,
        size: Vector2(455.3.w, 256.w),
        children: [water1]);

    SpriteComponent water2 = SpriteComponent(
        sprite: await Sprite.load("minigame/water/water.png"),
        size: Vector2(455.3.w, 256.w),
        position: Vector2(188.w - 12.w, 49.w) / 3);

    PositionComponent waterComponent2 = PositionComponent(
        anchor: Anchor.center,
        position:
            Vector2(455.3.w, 256.w) / 2 + Vector2(188.w - 11.w, -49.w) / 3,
        size: Vector2(455.3.w, 256.w),
        children: [water2]);

    ClickableSprite tap1 = ClickableSprite(
        isBtn: false,
        position: Vector2(471.w, 256.w) / 3,
        extraPosition: Vector2(-12.w, 0) / 3,
        size: Vector2(40.w, 25.w) / 3,
        onClickEvent: (position, component) {
          waterComponent1.scale.x *= 0.8;
          if (waterComponent1.scale.x < 0.5) waterComponent1.removeFromParent();
        },
        src: "minigame/water/tap.png");

    ClickableSprite tap2 = ClickableSprite(
        isBtn: false,
        position: Vector2(838.w, 256.w) / 3,
        extraPosition: Vector2(376.w - 23.w, 0) / 3,
        size: Vector2(40.w, 25.w) / 3,
        onClickEvent: (position, component) {
          waterComponent2.scale.x *= 0.8;
          if (waterComponent2.scale.x < 0.5) waterComponent2.removeFromParent();
        },
        src: "minigame/water/tap.png");

    TextBoxComponent gameText = TextBoxComponent(
        text: tr("water_off"),
        align: Anchor.center,
        anchor: Anchor.center,
        position: Vector2(227.65.w, 226.w),
        size: Vector2(362, 22.w),
        textRenderer: TextPaint(style: AppTypography.whitePixel),
        boxConfig: const TextBoxConfig(timePerChar: 0.1, growingBox: true));

    ClickableSprite xBtn = ClickableSprite(
        isBtn: true,
        position: Vector2(10.w, 13.w),
        size: Vector2.all(14.w),
        onClickEvent: (position, component) {
          bool result = waterComponent1.isRemoved && waterComponent2.isRemoved;
          Navigator.of(AppRouter.navigatorKey.currentContext!).pop(result);
        },
        src: "minigame/xBtn.png");

    add(background);
    add(toiletBackground);
    add(xBtn);
    add(gameText);
    addAll([waterComponent1, waterComponent2, tap1, tap2]);

    return super.onMount();
  }
}
