import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

class Background extends PositionComponent
    with HasGameReference<SinkingUsGame>, CollisionCallbacks {
  late SpriteComponent background;
  double mapRatio;
  late RectangleHitbox hitbox;

  Background({required this.mapRatio});

  @override
  FutureOr<void> onLoad() async {
    Sprite backgroundSprite = await Sprite.load("map1.jpg");
    background = SpriteComponent(
        sprite: backgroundSprite,
        size: backgroundSprite.originalSize * mapRatio,
        anchor: Anchor.topCenter,
        position:
            Vector2(0, backgroundSprite.originalSize.y * mapRatio * -0.5) +
                game.camera.viewport.virtualSize * 0.5);

    final background2 = SpriteComponent(
        sprite: await Sprite.load("map2.png"),
        size: backgroundSprite.originalSize * mapRatio,
        anchor: Anchor.topCenter,
        position:
            Vector2(0, backgroundSprite.originalSize.y * mapRatio * -0.5) +
                game.camera.viewport.virtualSize * 0.5);

    ShowDialogHelper.showSnackBar(content: "test");
    hitbox = RectangleHitbox(
        position: background.size * 0.5 + Vector2(300.w, 300.w),
        anchor: Anchor.center,
        size: Vector2.all(200.w),
        isSolid: true);

    final temp = RectangleComponent(
        position: background.size * 0.5 + Vector2(300.w, 300.w),
        anchor: Anchor.center,
        size: Vector2.all(200.w))
      ..paint = BasicPalette.red.paint();

    background.add(hitbox);
    background.add(temp);

    add(background);
    add(background2);

    return super.onLoad();
  }

  // @override
  // void update(double dt) {
  //   if (hitbox.isColliding) {
  //     print(hitbox.intersections(game.player.hitbox));
  //   }
  //   super.update(dt);
  // }
}
