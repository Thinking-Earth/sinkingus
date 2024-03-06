import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

@JsonEnum(valueField: 'code')
enum GroceryType {
  goodWater(0, "goodWater", 120, 10, "this is good"),
  badWater(1, "badWater", 60, 20, "this is bad"),
  goodFood(2, "goodFood", 120, 10, "this is good"),
  badFood(3, "badFood", 60, 20, "this is bad"),
  goodAir(4, "goodAir", 120, 10, "this is good"),
  badAir(5, "badAir", 60, 20, "this is bad"),
  goodClothes(6, "goodClothes", 120, 10, "this is good"),
  badClothes(7, "badClothes", 60, 20, "this is bad");

  const GroceryType(
      this.id, this.code, this.price, this.destroyScore, this.description);
  final String code;
  final int id;
  final int price;
  final int destroyScore;
  final String description;
}

class GroceryListItem extends SpriteComponent {
  GroceryType type;
  GroceryListItem({required this.type})
      : super(position: Vector2(418.w * (type.id - 2), 0) / 3);

  @override
  FutureOr<void> onMount() async {
    sprite = await Sprite.load("store/${type.code}.png");
    size = Vector2(455.3.w, 256.w);

    final priceComponent = TextComponent(
        text: "${type.price}",
        position: Vector2(1028.w, 340.w) / 3,
        textRenderer: TextPaint(style: AppTypography.blackPixel));
    add(priceComponent);

    final destroyComponent = TextComponent(
        text: "-${type.destroyScore}",
        position: Vector2(1188.w, 340.w) / 3,
        textRenderer: TextPaint(style: AppTypography.blackPixel));
    add(destroyComponent);

    final buyBtn = ClickableSprite(
        position: Vector2(1018.w, 539.w) / 3,
        size: Vector2(168.w, 57.w) / 3,
        onClickEvent: (positon, component) {},
        src: "store/buyBtn.png");
    add(buyBtn);

    final buyText = TextComponent(
        text: "buy",
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        size: Vector2(168.w, 57.w) / 3,
        position: Vector2(1018.w, 539.w) / 3 + Vector2(168.w, 57.w) / 6);
    add(buyText);

    final description = TextComponent(
        text: type.description,
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        size: Vector2(290.w, 125.w) / 3,
        position: Vector2(1104.w, 464.5.w) / 3);
    add(description);

    return super.onMount();
  }
}

class BuyNecessityDialog extends FlameGame with HasKeyboardHandlerComponents {
  late Scroller scroller;
  late PositionComponent listView;

  @override
  FutureOr<void> onMount() async {
    final background = SpriteComponent(
        sprite: await Sprite.load("store/background.png"),
        size: Vector2(455.3.w, 256.w));

    final background2 = SpriteComponent(
        sprite: await Sprite.load("store/background2.png"),
        size: Vector2(1366.w, 655.w) / 3);

    ClickableSprite xBtn = ClickableSprite(
        position: Vector2(14.w, 6.w) / 3,
        size: Vector2.all(40.w) / 3,
        onClickEvent: (position, component) {
          Navigator.of(AppRouter.navigatorKey.currentContext!).pop(true);
        },
        src: "store/xBtn.png");

    final goodWater = GroceryListItem(type: GroceryType.goodWater);
    final badWater = GroceryListItem(type: GroceryType.badWater);
    final goodFood = GroceryListItem(type: GroceryType.goodFood);
    final badFood = GroceryListItem(type: GroceryType.badFood);
    final goodAir = GroceryListItem(type: GroceryType.goodAir);
    final badAir = GroceryListItem(type: GroceryType.badAir);
    final goodClothes = GroceryListItem(type: GroceryType.goodClothes);
    final badClothes = GroceryListItem(type: GroceryType.badClothes);
    listView = PositionComponent(children: [
      goodWater,
      badWater,
      goodFood,
      badFood,
      goodAir,
      badAir,
      goodClothes,
      badClothes
    ]);

    scroller = Scroller(scrollView: listView);

    ClickablePolygon leftScrollBtn = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        onClickEvent: () {
      scroller.scrollPosition = max(0.w, scroller.scrollPosition - 20.w);
    }, parentSize: Vector2(48.w, 44.w) / 3)
      ..position = Vector2(66.w, 666.w) / 3
      ..paint = BasicPalette.transparent.paint();

    ClickablePolygon rightScrollBtn = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        onClickEvent: () {
      scroller.scrollPosition = min(989.w / 3, scroller.scrollPosition + 20.w);
    }, parentSize: Vector2(48.w, 44.w) / 3)
      ..position = Vector2(1250.w, 666.w) / 3
      ..paint = BasicPalette.transparent.paint();

    add(background);
    add(listView);
    add(background2);
    add(xBtn);
    add(scroller);
    add(leftScrollBtn);
    add(rightScrollBtn);

    return super.onMount();
  }
}
