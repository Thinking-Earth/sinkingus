import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/mini_game/select_policy_dialog.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';
import 'package:sinking_us/feature/game/sprites/news.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

class GameUI extends PositionComponent
    with RiverpodComponentMixin, HasGameReference<SinkingUsGame> {
  Vector2 cameraSize;
  bool isHost;
  late HudButtonComponent gameLeaveBtn;
  late TextButton gameStartBtn;
  late RectangleComponent hp, natureScore;
  late Timer timer;
  int oneDay = 50;
  int remainingSec = 50;

  late TextBoxComponent timerComponent,
      moneyComponent,
      dayComponent,
      peopleComponent;

  late News news;

  GameUI(this.cameraSize, this.isHost);

  @override
  FutureOr<void> onLoad() async {
    gameLeaveBtn = HudButtonComponent(
        button: SpriteComponent(
            sprite: await Sprite.load("etc/leave.png"),
            size: Vector2.all(18.w)),
        onPressed: () async {
          game.pauseEngine();
          game.removeFromParent();
          game.state.leaveMatch(false);
        },
        size: Vector2.all(18 * 1.8),
        position: Vector2(cameraSize.x, 0),
        anchor: Anchor.topRight);

    hp = RectangleComponent(
        anchor: Anchor.centerLeft,
        position: Vector2(23, 9) * 1.w,
        size: Vector2(58, 8) * 1.w,
        paint: Paint()..color = const Color.fromARGB(255, 225, 234, 0));

    final hpUi = SpriteComponent(
        sprite: await Sprite.load("etc/hpBar.png"),
        position: Vector2(5.w, 0),
        anchor: Anchor.topLeft,
        size: Vector2(89, 18) * 1.w)
      ..add(hp);

    natureScore = RectangleComponent(
        anchor: Anchor.centerLeft,
        position: Vector2(23, 9) * 1.w,
        size: Vector2(58, 8) * 1.w,
        paint: Paint()..color = const Color.fromARGB(255, 0, 247, 86));

    final natureUi = SpriteComponent(
        sprite: await Sprite.load("etc/natureScoreBar.png"),
        position: Vector2(hpUi.size.x + 3.w, 0),
        anchor: Anchor.topLeft,
        size: Vector2(89, 18) * 1.w)
      ..add(natureScore);

    final coinUi = SpriteComponent(
        sprite: await Sprite.load("etc/coin.png"),
        anchor: Anchor.topRight,
        position: Vector2(cameraSize.x - gameLeaveBtn.size.x - 60.w, 0.5.w),
        size: Vector2.all(18.w));

    moneyComponent = TextBoxComponent(
        text: "${game.state.money}",
        size: Vector2(25.w, 18.w),
        anchor: Anchor.topRight,
        align: Anchor.center,
        position: coinUi.position - Vector2(coinUi.size.x, 0),
        textRenderer: TextPaint(style: AppTypography().blackPixel));

    peopleComponent = TextBoxComponent(
        text: "${game.players.length + 1}/6",
        size: Vector2(25.w, 18.w),
        anchor: Anchor.topRight,
        align: Anchor.center,
        position:
            moneyComponent.position - Vector2(moneyComponent.size.x + 20.w, 0),
        textRenderer: TextPaint(style: AppTypography().blackPixel));

    final peopleIcon = SpriteComponent(
        sprite: await Sprite.load("etc/peopleIcon.png"),
        size: Vector2.all(18.w),
        anchor: Anchor.topRight,
        position:
            peopleComponent.position - Vector2(peopleComponent.size.x, 0));

    dayComponent = TextBoxComponent(
        text: "DAY ${game.day}",
        size: Vector2(50.w, 18.w),
        anchor: Anchor.topRight,
        align: Anchor.center,
        position: peopleComponent.position -
            Vector2(peopleComponent.size.x + 40.w, 0),
        textRenderer: TextPaint(style: AppTypography().blackPixel));

    gameStartBtn = TextButton(
        text: "Start Game",
        onPressed: hostStartGame,
        size: Vector2(100.w, 30.h),
        position: Vector2(cameraSize.x * 0.5, 0),
        anchor: Anchor.topCenter);

    final minimap = SpriteComponent(
        sprite: await Sprite.load("etc/minimap.png"),
        anchor: Anchor.bottomRight,
        position: cameraSize - Vector2.all(20.w),
        size: Vector2.all(100.w))
      ..opacity = 0.6;

    timer = Timer(1, onTick: () {
      remainingSec -= 1;
      timerComponent.text =
          "0${remainingSec ~/ 60} : ${(remainingSec % 60 < 10) ? "0" : ""}${remainingSec % 60}";
      if (remainingSec == 0) {
        timer.pause();
        if (isHost) {
          game.state.hostNextDay();
        }
      }
    }, repeat: true, autoStart: false);

    timerComponent = TextBoxComponent(
        text: "",
        textRenderer: TextPaint(style: AppTypography().timerPixel),
        position: Vector2(cameraSize.x * 0.5, 10.w),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter);

    news = News(game: game);

    add(gameLeaveBtn);
    add(hpUi);
    add(natureUi);
    add(coinUi);
    add(moneyComponent);
    add(peopleComponent);
    add(peopleIcon);
    add(dayComponent);
    add(minimap);

    return super.onLoad();
  }

  @override
  void onMount() {
    if (isHost && game.day == 0) {
      add(gameStartBtn);
    } else if (game.day > 0) {
      timer.stop();
      int elapsedSec = (DateTime.now().millisecondsSinceEpoch -
                  ref.read(matchDomainControllerProvider).dayChangedTime) ~/
              1000 -
          8;
      remainingSec = oneDay - elapsedSec;
      add(timerComponent);
    }
    super.onMount();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);

    moneyComponent.text = "${game.state.money}";
    peopleComponent.text = "${game.players.length + 1}/6";
    dayComponent.text = "DAY ${game.day}";
    hp.scale = Vector2(game.state.hp / 100, 1);
    natureScore.scale = Vector2(game.state.natureScore / 100, 1);
  }

  // called when day updated to 1
  void startGame() {
    add(timerComponent);
    setNewsText();
    ShowDialogHelper.gameEventDialog(
            text: "news", widget: GameWidget(game: news))
        .then((value) {
      game.state.currentEvent = GameEventType.undefined.id;
      value ? timer.start() : ();
    });
  }

  // called when day updated
  void nextDay(int day) {
    setNewsText();
    ShowDialogHelper.gameEventDialog(
            text: "news", widget: GameWidget(game: news))
        .then((value) {
      game.state.currentEvent = GameEventType.undefined.id;
      timer.pause();
      remainingSec = oneDay;
      timer.start();
    });
  }

  void setNewsText() {
    if (game.day == 0) {
      news.text = tr("game_started");
    } else if (game.state.rule.id == RuleType.carbonNeutrality.id) {
      news.text = tr("news_greenplation");
    } else if (game.state.natureScore > 80) {
      news.text = tr("news_80");
    } else if (game.state.natureScore > 60) {
      news.text = tr("news_60");
    } else if (game.state.natureScore > 40) {
      news.text = tr("news_40");
    } else if (game.state.natureScore > 20) {
      news.text = tr("news_20");
    } else if (game.state.natureScore > 0) {
      news.text = tr("news_0");
    }
  }

  void hostStartGame() async {
    if (game.players.length == 1) {
      // TODO
      gameStartBtn.removeFromParent();
      game.state.hostStartGame();
    } else {
      ShowDialogHelper.showSnackBar(content: tr('gamePage_cannotStart'));
    }
  }

  void gameNotification(String text) {
    add(NotiSprite(text, cameraSize));
  }
}

class NotiSprite extends SpriteComponent {
  String text;
  NotiSprite(this.text, Vector2 cameraSize)
      : super(
            position: Vector2(cameraSize.x * 0.5, cameraSize.y * 0.2),
            anchor: Anchor.center,
            size: Vector2(max(15.w * text.length, 180.w), 20.w));

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("etc/notibackground.png");
    final textSprite = TextComponent(
        text: text,
        textRenderer: TextPaint(style: AppTypography().whitePixel),
        anchor: Anchor.center,
        position: size * 0.5);
    add(textSprite);

    final effect = SequenceEffect([
      OpacityEffect.to(
        0,
        EffectController(duration: 0.3, startDelay: 2),
      ),
      RemoveEffect(),
    ]);
    add(effect);

    return super.onLoad();
  }
}

class TextButton extends SpriteComponent with TapCallbacks {
  String text;
  Function onPressed;
  TextButton(
      {required this.text,
      required this.onPressed,
      super.size,
      super.anchor,
      super.position});
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load("etc/button.png");
    final textComponent = TextComponent(
        text: text,
        textRenderer: TextPaint(style: AppTypography().blackPixel),
        anchor: Anchor.center,
        position: size * 0.5);
    add(textComponent);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    onPressed();
    super.onTapUp(event);
  }
}
