import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class TreeGame extends FlameGame {
  @override
  FutureOr<void> onMount() async {
    SpriteComponent background = SpriteComponent(
        sprite: await Sprite.load("minigame/pop up.jpg"),
        size: Vector2(455.3.w, 256.w));

    SpriteComponent forestBackground = SpriteComponent(
        sprite: await Sprite.load("minigame/tree/forest.png"),
        size: Vector2(455.3.w, 256.w));

    SpriteComponent sprout1 = SpriteComponent(
        sprite: await Sprite.load("minigame/tree/sprout.png"),
        size: Vector2(455.3.w, 256.w),
        position: -Vector2(570.w, 405.w) / 3 + Vector2(1.w, 2.w));

    PositionComponent sproutComponent1 = PositionComponent(
        anchor: Anchor.bottomCenter,
        position: Vector2(570.w, 405.w) / 3,
        children: [sprout1],
        size: Vector2(2.w, 2.w));

    ClickablePolygon sproutBtn1 = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        parentSize: Vector2(54.w, 35.w) / 3, onClickEvent: () {
      if (!sproutComponent1.isMounted) {
        sproutComponent1.scale = Vector2.all(0.25);
        add(sproutComponent1);
      } else if (sproutComponent1.scale.x < 1) {
        sproutComponent1.scale += Vector2.all(0.25);
      }
    })
      ..position = Vector2(539.w, 398.w) / 3
      ..paint = BasicPalette.transparent.paint();

    SpriteComponent sprout2 = SpriteComponent(
        sprite: await Sprite.load("minigame/tree/sprout.png"),
        size: Vector2(455.3.w, 256.w),
        position: -Vector2(806.w, 318.w) / 3 +
            Vector2(1.w, 2.w) +
            (Vector2(806.w, 318.w) - Vector2(570.w, 405.w)) / 3);

    PositionComponent sproutComponent2 = PositionComponent(
        anchor: Anchor.bottomCenter,
        position: Vector2(806.w, 318.w) / 3,
        children: [sprout2],
        size: Vector2(2.w, 2.w));

    ClickablePolygon sproutBtn2 = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        parentSize: Vector2(54.w, 35.w) / 3, onClickEvent: () {
      if (!sproutComponent2.isMounted) {
        sproutComponent2.scale = Vector2.all(0.25);
        add(sproutComponent2);
      } else if (sproutComponent2.scale.x < 1) {
        sproutComponent2.scale += Vector2.all(0.25);
      }
    })
      ..position = Vector2(773.w, 308.w) / 3
      ..paint = BasicPalette.transparent.paint();

    SpriteComponent sprout3 = SpriteComponent(
        sprite: await Sprite.load("minigame/tree/sprout.png"),
        size: Vector2(455.3.w, 256.w),
        position: -Vector2(528.w, 262.w) / 3 +
            Vector2(1.w, 2.w) +
            (Vector2(528.w, 262.w) - Vector2(570.w, 405.w)) / 3);

    PositionComponent sproutComponent3 = PositionComponent(
        anchor: Anchor.bottomCenter,
        position: Vector2(528.w, 262.w) / 3,
        children: [sprout3],
        size: Vector2(2.w, 2.w));

    ClickablePolygon sproutBtn3 = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        parentSize: Vector2(54.w, 35.w) / 3, onClickEvent: () {
      if (!sproutComponent3.isMounted) {
        sproutComponent3.scale = Vector2.all(0.25);
        add(sproutComponent3);
      } else if (sproutComponent3.scale.x < 1) {
        sproutComponent3.scale += Vector2.all(0.25);
      }
    })
      ..position = Vector2(494.w, 257.w) / 3
      ..paint = BasicPalette.transparent.paint();

    TextBoxComponent gameText = TextBoxComponent(
        text: tr("tree_game"),
        align: Anchor.center,
        anchor: Anchor.center,
        position: Vector2(227.65.w, 226.w),
        size: Vector2(362, 22.w),
        textRenderer: TextPaint(style: AppTypography.whitePixel),
        boxConfig: const TextBoxConfig(timePerChar: 0.1, growingBox: true));

    ClickableSprite xBtn = ClickableSprite(
        position: Vector2(10.w, 13.w),
        size: Vector2.all(14.w),
        onClickEvent: (position, component) {
          bool result = sproutComponent1.scale.x == 1 &&
              sproutComponent2.scale.x == 1 &&
              sproutComponent3.scale.x == 1;
          Navigator.of(AppRouter.navigatorKey.currentContext!).pop(result);
        },
        src: "minigame/xBtn.png");

    add(background);
    add(forestBackground);
    add(xBtn);
    add(gameText);
    addAll([sproutBtn1, sproutBtn2, sproutBtn3]);
    return super.onMount();
  }
}
