import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
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
  int oneDay = 150; // TODO: test version time
  int remainingSec = 150;
  late TextComponent timerComponent, moneyComponent;
  late News news;

  GameUI(this.cameraSize, this.isHost);

  @override
  FutureOr<void> onLoad() async {
    gameLeaveBtn = HudButtonComponent(
        button: SpriteComponent(
            sprite: await Sprite.load("etc/leave.png"),
            size: Vector2.all(18 * 1.8)),
        onPressed: () async {
          game.pauseEngine();
          game.removeFromParent();
          game.state.leaveMatch();
        },
        size: Vector2.all(18 * 1.8),
        position: Vector2(cameraSize.x, 0),
        anchor: Anchor.topRight);

    hp = RectangleComponent(
        anchor: Anchor.centerLeft,
        position: Vector2(23, 9) * 1.8,
        size: Vector2(58, 8) * 1.8,
        scale: Vector2.all(1),
        paint: Paint()..color = const Color.fromARGB(255, 225, 234, 0));

    final hpUi = SpriteComponent(
        sprite: await Sprite.load("etc/hpBar.png"),
        position: Vector2(5.w, 0),
        anchor: Anchor.topLeft,
        size: Vector2(89, 18) * 1.8)
      ..add(hp);

    natureScore = RectangleComponent(
        anchor: Anchor.centerLeft,
        position: Vector2(23, 9) * 1.8,
        size: Vector2(58, 8) * 1.8,
        scale: Vector2.all(1),
        paint: Paint()..color = const Color.fromARGB(255, 0, 247, 86));

    final natureUi = SpriteComponent(
        sprite: await Sprite.load("etc/natureScoreBar.png"),
        position: Vector2(hpUi.size.x + 3.w, 0),
        anchor: Anchor.topLeft,
        size: Vector2(89, 18) * 1.8)
      ..add(natureScore);

    final coinUi = SpriteComponent(
        sprite: await Sprite.load("etc/coin.png"),
        anchor: Anchor.topLeft,
        position: Vector2(cameraSize.x - gameLeaveBtn.size.x - 30.w * 1.8, 0),
        size: Vector2.all(18) * 1.8);

    moneyComponent = TextComponent(
        text: "${game.state.money}",
        anchor: Anchor.topRight,
        position: coinUi.position + Vector2(-3.w, 3 * 1.8),
        textRenderer: TextPaint(style: AppTypography.blackPixel));

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

    timerComponent = TextComponent(
        text: "",
        textRenderer: TextPaint(style: AppTypography.timerPixel),
        position: Vector2(cameraSize.x * 0.5, 10.w),
        anchor: Anchor.topCenter);

    news = News(game);

    add(gameLeaveBtn);
    add(hpUi);
    add(natureUi);
    add(moneyComponent);
    add(coinUi);
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
    hp.scale = Vector2(game.state.hp / 100, 1);
    natureScore.scale = Vector2(game.state.natureScore / 100, 1);
  }

  // called when day updated to 1
  void startGame() {
    add(timerComponent);
    news.text = "Game started";
    ShowDialogHelper.gameEventDialog(
            text: "news", widget: GameWidget(game: news))
        .then((value) {
      game.state.currentEvent = GameEventType.undefined.id;
      value ? timer.start() : ();
    });
  }

  // called when day updated
  void nextDay(int day) {
    news.text = "It's day $day";
    ShowDialogHelper.gameEventDialog(
            text: "news", widget: GameWidget(game: news))
        .then((value) {
      game.state.currentEvent = GameEventType.undefined.id;
      timer.pause();
      remainingSec = oneDay;
      timer.start();
    });
  }

  void hostStartGame() async {
    if (game.players.length == 5) {
      gameStartBtn.removeFromParent();
      game.state.hostStartGame();
    } else {
      // TODO: 사람이 6명이어야 게임 시작 가능
      gameStartBtn.removeFromParent();
      game.state.hostStartGame();
    }
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
        textRenderer: TextPaint(style: AppTypography.blackPixel),
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
