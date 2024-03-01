import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';

class SunPowerGame extends FlameGame {
  @override
  FutureOr<void> onLoad() async {
    SpriteComponent background = SpriteComponent(
        sprite: await Sprite.load("minigame/pop up.jpg"),
        size: Vector2(455.3.w, 256.w));

    SpriteComponent sunBackground = SpriteComponent(
        sprite: await Sprite.load("minigame/sun/sun.png"),
        size: Vector2(455.3.w, 256.w));

    SpriteComponent dirt = SpriteComponent(
        sprite: await Sprite.load("minigame/sun/dirt.png"),
        size: Vector2(455.3.w, 256.w));

    ClickableSprite xBtn = ClickableSprite(
        position: Vector2(10.w, 13.w),
        size: Vector2.all(14.w),
        onClickEvent: (position, component) {
          bool result = false;
          Navigator.of(AppRouter.navigatorKey.currentContext!).pop(result);
        },
        src: "minigame/xBtn.png");

    add(background);
    add(sunBackground);
    add(dirt);
    add(xBtn);
    return super.onLoad();
  }
}
