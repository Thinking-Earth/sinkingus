import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
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
  late SpriteComponent hpUi, natureUi, coinUi;
  late Timer timer;
  int oneDay = 10;
  int remainingSec = 10; // TODO: test version time
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
          await ref.read(matchDomainControllerProvider.notifier).leaveMatch();
        },
        size: Vector2.all(18 * 1.8),
        position: Vector2(cameraSize.x, 0),
        anchor: Anchor.topRight);

    hpUi = SpriteComponent(
        sprite: await Sprite.load("etc/hpBar.png"),
        position: Vector2(5.w, 0),
        anchor: Anchor.topLeft,
        size: Vector2(89, 18) * 1.8)
      ..add(RectangleComponent(
          anchor: Anchor.centerLeft,
          position: Vector2(23, 9) * 1.8,
          size: Vector2(58, 8) * 1.8,
          scale: Vector2(game.hp / 100, 1),
          paint: Paint()..color = const Color.fromARGB(255, 225, 234, 0)));

    natureUi = SpriteComponent(
        sprite: await Sprite.load("etc/natureScoreBar.png"),
        position: Vector2(hpUi.size.x + 3.w, 0),
        anchor: Anchor.topLeft,
        size: Vector2(89, 18) * 1.8)
      ..add(RectangleComponent(
          anchor: Anchor.centerLeft,
          position: Vector2(23, 9) * 1.8,
          size: Vector2(58, 8) * 1.8,
          scale: Vector2(game.hp / 100, 1),
          paint: Paint()..color = const Color.fromARGB(255, 0, 247, 86)));

    coinUi = SpriteComponent(
        sprite: await Sprite.load("etc/coin.png"),
        anchor: Anchor.topLeft,
        position: Vector2(cameraSize.x - gameLeaveBtn.size.x - 30.w * 1.8, 0),
        size: Vector2.all(18) * 1.8);

    moneyComponent = TextComponent(
        text: "${game.money}",
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
          ref.read(matchDomainControllerProvider.notifier).hostNextDay();
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
      remainingSec = oneDay - elapsedSec; // TODO: test version time
      add(timerComponent);
    }
    super.onMount();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);
  }

  // called when day updated to 1
  void startGame() {
    ref.read(matchDomainControllerProvider.notifier).setNextDay(1);
    add(timerComponent);
    news.text = "Game started";
    ShowDialogHelper.gameEventDialog(
            text: "news", widget: GameWidget(game: news))
        .then((value) {
      game.setCurrentEvent(GameEventType.undefined.id);
      value ? timer.start() : ();
    });
  }

  // called when day updated
  void nextDay(int day) {
    ref.read(matchDomainControllerProvider.notifier).setNextDay(day);
    news.text = "It's day $day";
    ShowDialogHelper.gameEventDialog(
            text: "news", widget: GameWidget(game: news))
        .then((value) {
      game.setCurrentEvent(GameEventType.undefined.id);
      timer.pause();
      remainingSec = oneDay; // TODO: test version time
      timer.start();
    });
    timer.resume();
  }

  void hostStartGame() async {
    if (game.players.length >= 5) {
      await ref.read(matchDomainControllerProvider.notifier).hostStartGame();
      gameStartBtn.removeFromParent();
    } else {
      // TODO: 사람이 적어서 게임 시작 불가로 바꾸기
      await ref.read(matchDomainControllerProvider.notifier).hostStartGame();
      gameStartBtn.removeFromParent();
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
