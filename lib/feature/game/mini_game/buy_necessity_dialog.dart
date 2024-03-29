import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/game_widgets/game_riverpod.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

@JsonEnum(valueField: 'code')
enum GroceryType {
  goodClothes(0, "goodClothes", 160, 15),
  badClothes(1, "badClothes", 40, 30),
  goodFood(2, "goodFood", 190, 12),
  badFood(3, "badFood", 70, 25),
  goodAir(4, "goodAir", 220, 8),
  badAir(5, "badAir", 100, 20),
  goodWater(6, "goodWater", 250, 5),
  badWater(7, "badWater", 130, 18);

  const GroceryType(this.id, this.code, this.price, this.destroyScore);
  final String code;
  final int id;
  final int price;
  final int destroyScore;
}

class GroceryListItem extends SpriteComponent
    with HasGameReference<BuyNecessityDialog> {
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

    final destroyComponent = TextComponent(
        text: "-${type.destroyScore}",
        position: Vector2(1188.w, 340.w) / 3,
        textRenderer: TextPaint(style: AppTypography.blackPixel));

    final buyBtn = ClickableSprite(
        position: Vector2(1018.w, 539.w) / 3,
        size: Vector2(168.w, 57.w) / 3,
        onClickEvent: (positon, component) {
          game.showBuyDialog(type);
        },
        src: "store/buyBtn.png");
    add(buyBtn);

    final buyText = TextComponent(
        text: tr("buy"),
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        size: Vector2(168.w, 57.w) / 3,
        position: Vector2(1018.w, 539.w) / 3 + Vector2(168.w, 57.w) / 6);
    add(buyText);

    final description = TextComponent(
        text: tr("${type.code}_name"),
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        size: Vector2(290.w, 125.w) / 3,
        position: Vector2(1104.w, 464.5.w) / 3);

    add(priceComponent);
    add(destroyComponent);
    add(buyBtn);
    add(buyText);
    add(description);

    return super.onMount();
  }
}

class BuyDialog extends SpriteComponent
    with HasGameReference<BuyNecessityDialog> {
  GroceryType type;

  BuyDialog(this.type) : super(size: Vector2(455.3.w, 256.w));

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("store/dialog.png");

    final buyText = TextComponent(
        text: tr("buy"),
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        position: Vector2(730.w, 439.w) / 3);

    final cancelText = TextComponent(
        text: tr("close"),
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        position: Vector2(904.w, 439.w) / 3);

    final buyBtn = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        onClickEvent: () {
      if (game.state.rule.restrict >= type.destroyScore) {
        bool canBuy =
            game.state.setDt(20, -1 * type.destroyScore, -1 * type.price);
        if (canBuy) {
          ShowDialogHelper.showSnackBar(content: tr("buy_success"));
        } else {
          ShowDialogHelper.showSnackBar(content: tr("buy_fail"));
        }
      } else {
        ShowDialogHelper.showSnackBar(content: "규칙에 위배됩니다");
      }
    }, parentSize: Vector2(134.w, 42.w) / 3)
      ..position = Vector2(663.w, 419.w) / 3
      ..paint = BasicPalette.transparent.paint();

    final cancelBtn = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        onClickEvent: () {
      removeFromParent();
    }, parentSize: Vector2(134.w, 42.w) / 3)
      ..position = Vector2(837.w, 419.w) / 3
      ..paint = BasicPalette.transparent.paint();

    final description = TextComponent(
        text: tr("${type.code}_description"),
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        position: Vector2(684.w, 357.w) / 3);

    add(buyText);
    add(cancelText);
    add(buyBtn);
    add(cancelBtn);
    add(description);

    return super.onLoad();
  }
}

class Scroller extends PositionComponent with DragCallbacks, KeyboardHandler {
  PositionComponent listView;
  double scrollPosition = 0;

  Scroller({required this.listView})
      : super(
            size: Vector2(152.w, 44.w) / 3,
            position: Vector2(111.w, 666.w) / 3);

  @override
  FutureOr<void> onLoad() async {
    final scrollSpriteComponent = SpriteComponent(
        sprite: await Sprite.load("store/scroll.png"),
        size: Vector2(455.3.w, 256.w),
        position: -position + Vector2(111.w / 3 - 455.3.w / 2 + 76.w / 3, 0));
    add(scrollSpriteComponent);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x = 111.w / 3 + scrollPosition;
    listView.position.x = -scrollPosition * 2090 / 989;
    super.update(dt);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (event.localDelta.x > 0) {
      scrollPosition = min(989.w / 3, scrollPosition + event.localDelta.x);
    }
    if (event.localDelta.x < 0) {
      scrollPosition = max(0, scrollPosition + event.localDelta.x);
    }
    super.onDragUpdate(event);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      scrollPosition = max(0.w, scrollPosition - 20.w);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      scrollPosition = min(989.w / 3, scrollPosition + 20.w);
    }
    return super.onKeyEvent(event, keysPressed);
  }
}

class BuyNecessityDialog extends FlameGame with HasKeyboardHandlerComponents {
  late Scroller scroller;
  late PositionComponent listView;
  late BuyDialog dialog;

  GameState state;

  BuyNecessityDialog({required this.state});

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

    scroller = Scroller(listView: listView);

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

  void showBuyDialog(GroceryType type) {
    dialog = BuyDialog(type);
    add(dialog);
  }
}
