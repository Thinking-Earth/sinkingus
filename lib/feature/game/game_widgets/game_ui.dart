import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/sprites/news.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

class GameUI extends PositionComponent with RiverpodComponentMixin {
  Vector2 cameraSize;
  bool isHost;
  SinkingUsGame game;
  late HudButtonComponent gameLeaveBtn, gameStartBtn;
  late Timer timer;
  int remainingSec = 30; // TODO: test version time
  late TextComponent timerConponent;
  late News news;

  GameUI(this.game, this.cameraSize, this.isHost);

  @override
  FutureOr<void> onLoad() async {
    gameLeaveBtn = HudButtonComponent(
        button: SpriteComponent(
            sprite: await Sprite.load("etc/leave.png"),
            size: Vector2.all(20.w)),
        onPressed: () async {
          game.pauseEngine();
          game.removeFromParent();
          await ref.read(matchDomainControllerProvider.notifier).leaveMatch();
        },
        size: Vector2.all(20.w),
        position: Vector2(cameraSize.x, 0),
        anchor: Anchor.topRight);

    gameStartBtn = HudButtonComponent(
        button: TextBox("Start Game"),
        onPressed: hostStartGame,
        size: Vector2(100.w, 30.h),
        position: Vector2(cameraSize.x * 0.5, 0),
        anchor: Anchor.topCenter);

    timer = Timer(1, onTick: () {
      remainingSec -= 1;
      timerConponent.text =
          "0${remainingSec ~/ 60} : ${(remainingSec % 60 < 10) ? "0" : ""}${remainingSec % 60}";
      if (remainingSec == 0) {
        timer.pause();
        if (isHost) {
          ref.read(matchDomainControllerProvider.notifier).hostNextDay();
        }
      }
    }, repeat: true, autoStart: false);

    timerConponent = TextComponent(
        text: "02:30",
        textRenderer: TextPaint(style: AppTypography.timerPixel),
        position: Vector2(cameraSize.x * 0.5, 10.w),
        anchor: Anchor.topCenter);

    news = News();

    if (isHost) {
      add(gameStartBtn);
    }
    add(gameLeaveBtn);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);
  }

  // called when day updated to 1
  void startGame() {
    add(timerConponent);
    news.text = "Game started";
    ShowDialogHelper.gameEventDialog(
            text: "news", widget: GameWidget(game: news))
        .then((value) => value ? timer.start() : ());
  }

  // called when day updated
  void nextDay(int day) {
    timer.pause();
    news.text = "It's day $day";
    remainingSec = 30; // test version time
    ShowDialogHelper.gameEventDialog(
            text: "news", widget: GameWidget(game: news))
        .then((value) => value ? timer.resume() : ());
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

class TextBox extends TextBoxComponent {
  TextBox(String text)
      : super(
            text: text,
            textRenderer: TextPaint(style: AppTypography.blackPixel),
            size: Vector2(100.w, 30.h),
            align: Anchor.center);

  final bgPaint = Paint()..color = const Color.fromARGB(255, 119, 195, 65);
  final borderPaint = Paint()
    ..color = const Color(0xFF000000)
    ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect.deflate(2), borderPaint);
    super.render(canvas);
  }
}
