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
import 'package:sinking_us/feature/game/sprites/roles.dart';
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
  late TextComponent btnText;

  GroceryListItem({required this.type})
      : super(position: Vector2(418.w * (type.id - 2), 0) / 3);

  @override
  FutureOr<void> onLoad() async {
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
          game.showBuyDialog(this);
        },
        src: "store/buyBtn.png");
    add(buyBtn);

    if (game.state.game.player.role == RoleType.business) {
      btnText = TextComponent(
          text: tr("activate"),
          textRenderer: TextPaint(
              style: (game.groceryList[type]! > -1)
                  ? AppTypography.grayPixel
                  : AppTypography.blackPixel),
          anchor: Anchor.center,
          size: Vector2(168.w, 57.w) / 3,
          position: Vector2(1018.w, 539.w) / 3 + Vector2(168.w, 57.w) / 6);
    } else {
      btnText = TextComponent(
          text: tr("buy"),
          textRenderer: TextPaint(
              style: (game.groceryList[type]! > -1)
                  ? AppTypography.blackPixel
                  : AppTypography.grayPixel),
          anchor: Anchor.center,
          size: Vector2(168.w, 57.w) / 3,
          position: Vector2(1018.w, 539.w) / 3 + Vector2(168.w, 57.w) / 6);
    }

    final description = TextComponent(
        text: tr("${type.code}_name"),
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        size: Vector2(290.w, 125.w) / 3,
        position: Vector2(1104.w, 464.5.w) / 3);

    add(priceComponent);
    add(destroyComponent);
    add(buyBtn);
    add(btnText);
    add(description);

    return super.onLoad();
  }
}

class BuyDialog extends SpriteComponent
    with HasGameReference<BuyNecessityDialog> {
  GroceryListItem listItem;
  late TextComponent buyText;

  BuyDialog(this.listItem) : super(size: Vector2(455.3.w, 256.w));

  @override
  FutureOr<void> onMount() async {
    sprite = await Sprite.load("store/dialog.png");

    buyText = TextComponent(
        text: listItem.btnText.text,
        textRenderer: listItem.btnText.textRenderer,
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
      if (game.state.game.player.role == RoleType.business) {
        activate();
      } else {
        buy();
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
        text: tr("${listItem.type.code}_description"),
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        size: Vector2(300.w, 200.w) / 3,
        position: Vector2(684.w, 357.w) / 3);

    add(buyText);
    add(cancelText);
    add(buyBtn);
    add(cancelBtn);
    add(description);

    return super.onMount();
  }

  void activate() {
    bool canActivate = game.state.setDt(0, 0, -3 * listItem.type.price);
    if (canActivate) {
      game.state.setActivate(listItem.type);
      buyText.textRenderer = listItem.btnText.textRenderer =
          TextPaint(style: AppTypography.grayPixel);
    } else {
      ShowDialogHelper.showSnackBar(content: tr("buy_fail"));
    }
  }

  void buy() {
    if (game.groceryList[listItem.type]! > -1) {
      if (game.state.rule.restrict >= listItem.type.destroyScore) {
        bool canBuy = game.state.setDt(
            20, -1 * listItem.type.destroyScore, -1 * listItem.type.price);
        if (canBuy) {
          ShowDialogHelper.showSnackBar(content: tr("buy_success"));
          game.state.buy(listItem.type.price);
        } else {
          ShowDialogHelper.showSnackBar(content: tr("buy_fail"));
        }
      } else {
        ShowDialogHelper.showSnackBar(content: tr("rule_abort"));
      }
    } else {
      ShowDialogHelper.showSnackBar(content: tr("activate_abort"));
    }
  }
}

class Scroller extends PositionComponent
    with DragCallbacks, KeyboardHandler, HasGameReference<BuyNecessityDialog> {
  Scroller()
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
    position.x = 111.w / 3 + game.scrollPosition;
    super.update(dt);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (event.localDelta.x > 0) {
      game.scrollPosition =
          min(989.w / 3, game.scrollPosition + event.localDelta.x);
    }
    if (event.localDelta.x < 0) {
      game.scrollPosition = max(0, game.scrollPosition + event.localDelta.x);
    }
    super.onDragUpdate(event);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      game.scrollPosition = max(0.w, game.scrollPosition - 20.w);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      game.scrollPosition = min(989.w / 3, game.scrollPosition + 20.w);
    }
    return super.onKeyEvent(event, keysPressed);
  }
}

class ListView extends PositionComponent
    with DragCallbacks, HasGameReference<BuyNecessityDialog> {
  ListView({super.children});

  @override
  void update(double dt) {
    position.x = -game.scrollPosition * 2090 / 989;
    super.update(dt);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (event.localDelta.x > 0) {
      game.scrollPosition =
          min(989.w / 3, game.scrollPosition + event.localDelta.x * 989 / 2090);
    }
    if (event.localDelta.x < 0) {
      game.scrollPosition =
          max(0, game.scrollPosition + event.localDelta.x * 989 / 2090);
    }
    super.onDragUpdate(event);
  }
}

class BuyNecessityDialog extends FlameGame with HasKeyboardHandlerComponents {
  late Scroller scroller;
  double scrollPosition = 0;
  late ListView listView;
  late BuyDialog dialog;

  GameState state;
  late Map<GroceryType, int> groceryList;

  BuyNecessityDialog({required this.state});

  @override
  FutureOr<void> onLoad() async {
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

    groceryList = await state.getGroceryList();

    final goodWater = GroceryListItem(type: GroceryType.goodWater);
    final badWater = GroceryListItem(type: GroceryType.badWater);
    final goodFood = GroceryListItem(type: GroceryType.goodFood);
    final badFood = GroceryListItem(type: GroceryType.badFood);
    final goodAir = GroceryListItem(type: GroceryType.goodAir);
    final badAir = GroceryListItem(type: GroceryType.badAir);
    final goodClothes = GroceryListItem(type: GroceryType.goodClothes);
    final badClothes = GroceryListItem(type: GroceryType.badClothes);
    listView = ListView(children: [
      goodWater,
      badWater,
      goodFood,
      badFood,
      goodAir,
      badAir,
      goodClothes,
      badClothes
    ]);

    scroller = Scroller();

    ClickablePolygon leftScrollBtn = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        onClickEvent: () {
      scrollPosition = max(0.w, scrollPosition - 20.w);
    }, parentSize: Vector2(48.w, 44.w) / 3)
      ..position = Vector2(66.w, 666.w) / 3
      ..paint = BasicPalette.transparent.paint();

    ClickablePolygon rightScrollBtn = ClickablePolygon.relative(
        [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)],
        onClickEvent: () {
      scrollPosition = min(989.w / 3, scrollPosition + 20.w);
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

    return super.onLoad();
  }

  void showBuyDialog(GroceryListItem listItem) {
    dialog = BuyDialog(listItem);
    add(dialog);
  }
}
