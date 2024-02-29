import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

class GameUI extends PositionComponent with RiverpodComponentMixin {
  Vector2 cameraSize;
  bool isHost;
  GameUI(this.cameraSize, this.isHost);

  @override
  FutureOr<void> onLoad() async {
    final gameLeaveBtn = HudButtonComponent(
        button: SpriteComponent(
            sprite: await Sprite.load("etc/leave.png"),
            size: Vector2.all(20.w)),
        onPressed: () async {
          await ref.read(matchDomainControllerProvider.notifier).leaveMatch();
        },
        size: Vector2.all(20.w),
        position: Vector2(cameraSize.x, 0),
        anchor: Anchor.topRight);

    final gameStartBtn = HudButtonComponent(
        button: TextBox("Start Game"),
        onPressed: hostStartGame,
        size: Vector2(100.w, 30.h),
        position: Vector2(cameraSize.x * 0.5, 0),
        anchor: Anchor.topCenter);

    if (isHost) {
      add(gameStartBtn);
    }
    add(gameLeaveBtn);

    return super.onLoad();
  }

  void hostStartGame() {
    ref.read(matchDomainControllerProvider.notifier).nextDay();
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
