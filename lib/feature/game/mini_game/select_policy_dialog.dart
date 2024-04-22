import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/game/game_widgets/game_riverpod.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

@JsonEnum(valueField: 'id')
enum RuleType {
  noRule(0, "noRule", 30),
  greenGrowthStrategy(1, "greenGrowthStrategy", 20),
  greenDeal(2, "greenDeal", 15),
  parisAgreement(3, "parisAgreement", 12),
  carbonNeutrality(4, "carbonNeutrality", 5);

  const RuleType(this.id, this.code, this.restrict);
  final int id;
  final String code;
  final int restrict;

  factory RuleType.getById(int id) {
    return RuleType.values
        .firstWhere((value) => value.id == id, orElse: () => RuleType.noRule);
  }
}

class PolicyListItem extends SpriteComponent
    with HasGameReference<PolicyDialog> {
  RuleType type;
  late ClickableSprite selectBtn;
  late TextComponent select;

  PolicyListItem({required this.type})
      : super(
            size: Vector2(368.w, 526.w) / 3,
            position: Vector2(type.id * 404.w, 0) / 3);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("policy/listitem.png");
    selectBtn = ClickableSprite(
        position: Vector2(101.5.w, 424.w) / 3,
        extraPosition: Vector2(101.5.w, 424.w) / 3,
        size: Vector2(165.w, 44.w) / 3,
        spriteSize: Vector2(165.w, 44.w) / 3,
        onClickEvent: (position, component) {
          game.selectPolicy(type);
        },
        src: "policy/selectBtn.png");

    select = TextComponent(
        text: tr("select"),
        anchor: Anchor.center,
        position: Vector2(184.w, 446.w) / 3,
        textRenderer: TextPaint(style: AppTypography.blackPixel));

    String title = tr(type.code);
    final titleText = TextComponent(
        text: title,
        anchor: Anchor.center,
        position: Vector2(size.x * 0.5, 20.w),
        textRenderer: TextPaint(
            style: AppTypography.blackPixel
                .copyWith(fontSize: (25 ~/ title.length + 3) * 2.sp)));

    final descriptionText = ScrollTextBoxComponent(
        text: tr("${type.code}_description"),
        anchor: Anchor.topCenter,
        position: Vector2(size.x * 0.5, 35.w),
        size: Vector2(300.w, 230.w) / 3,
        textRenderer: TextPaint(
            style: AppTypography.blackPixel.copyWith(fontSize: 8.sp)));

    final destroyScoreText = TextComponent(
        text: "-${type.restrict}",
        anchor: Anchor.centerLeft,
        position: Vector2(136.w, 380.w) / 3,
        textRenderer: TextPaint(style: AppTypography.blackPixel));

    add(selectBtn);
    add(select);
    add(titleText);
    add(descriptionText);
    add(destroyScoreText);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (selectBtn.isMounted) {
      if (game.state.rule == type) {
        selectBtn.sprite.opacity = 0.5;
        select
          ..text = tr("selected")
          ..textRenderer = TextPaint(style: AppTypography.grayPixel);
      } else {
        selectBtn.sprite.opacity = 1;
        select
          ..text = tr("select")
          ..textRenderer = TextPaint(style: AppTypography.blackPixel);
      }
    }
    super.update(dt);
  }
}

class Scroller extends SpriteComponent
    with DragCallbacks, KeyboardHandler, HasGameReference<PolicyDialog> {
  PositionComponent listView;

  Scroller({required this.listView});

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(152.w, 45.w) / 3;
    position = Vector2(68.w, 657.w) / 3;
    sprite = await Sprite.load("policy/scroll.png");
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x = 68.w / 3 + game.scrollPosition;
    super.update(dt);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (event.localDelta.x > 0) {
      game.scrollPosition =
          min(1080.w / 3, game.scrollPosition + event.localDelta.x);
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
    with DragCallbacks, HasGameReference<PolicyDialog> {
  ListView()
      : super(position: Vector2(93.w, 93.w) / 3, size: Vector2(1984.w, 526.w));

  @override
  void update(double dt) {
    position.x = 31.w - game.scrollPosition * 808 / 1080;
    super.update(dt);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (event.localDelta.x < 0) {
      game.scrollPosition =
          min(1080.w / 3, game.scrollPosition - event.localDelta.x);
    }
    if (event.localDelta.x > 0) {
      game.scrollPosition = max(0, game.scrollPosition - event.localDelta.x);
    }
    super.onDragUpdate(event);
  }
}

class PolicyDialog extends FlameGame {
  late ListView listView;
  double scrollPosition = 0.0;
  List<PolicyListItem> listItems = [];

  GameState state;

  PolicyDialog({required this.state});

  @override
  FutureOr<void> onLoad() async {
    final background = SpriteComponent(
        sprite: await Sprite.load("policy/background.png"),
        size: Vector2(455.3.w, 256.w));

    final background2 = SpriteComponent(
        sprite: await Sprite.load("policy/background2.png"),
        size: Vector2(455.3.w, 256.w));

    final xBtn = ClickableSprite(
        position: Vector2(45.w, 0) / 3,
        extraPosition: Vector2(45.w, 0) / 3,
        spriteSize: Vector2(49.w, 75.w) / 3,
        size: Vector2.all(50.w) / 3,
        onClickEvent: (position, component) {
          Navigator.of(AppRouter.navigatorKey.currentContext!).pop(true);
        },
        src: "policy/xBtn.png");

    listView = ListView();

    final item1 = PolicyListItem(type: RuleType.noRule);
    final item3 = PolicyListItem(type: RuleType.greenGrowthStrategy);
    final item4 = PolicyListItem(type: RuleType.greenDeal);
    final item5 = PolicyListItem(type: RuleType.parisAgreement);
    final item6 = PolicyListItem(type: RuleType.carbonNeutrality);

    listItems.addAll([item1, item3, item4, item5, item6]);
    listView.addAll(listItems);

    final scroller = Scroller(listView: listView);

    add(background);
    add(listView);
    add(background2);
    add(xBtn);
    add(scroller);

    return super.onLoad();
  }

  void selectPolicy(RuleType newRule) {
    if (state.game.player.role == RoleType.politician) {
      state.setRule(newRule);
    } else {
      ShowDialogHelper.showSnackBar(content: tr("rule_select_abort"));
    }
  }
}
