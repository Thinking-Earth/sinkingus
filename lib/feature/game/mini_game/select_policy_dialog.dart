import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';

class PolicyDialog extends FlameGame {
  @override
  FutureOr<void> onLoad() async {
    final background = SpriteComponent(
        sprite: await Sprite.load("policy/background.png"),
        size: Vector2(455.3.w, 256.w));
    final background2 = SpriteComponent(
        sprite: await Sprite.load("policy/background2.png"),
        size: Vector2(455.3.w, 256.w));

    //45 0 50*50
    final xBtn = ClickableSprite(
        position: Vector2(45.w, 0) / 3,
        extraPosition: Vector2(45.w, 0) / 3,
        size: Vector2.all(50.w) / 3,
        onClickEvent: (position, component) {},
        src: "policy/xBtn.png");

    add(background);
    add(background2);
    add(xBtn);

    return super.onLoad();
  }
}
