import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DragableSprite extends PositionComponent with DragCallbacks {
  String src;
  String changedSrc;
  late SpriteComponent sprite;
  Vector2 originalPosition;
  Vector2? extraPosition;
  bool Function(Vector2 position) goal;
  bool isGoal = false;

  DragableSprite(
      {required this.originalPosition,
      this.extraPosition,
      required this.goal,
      required Vector2 size,
      required this.src,
      required this.changedSrc})
      : super(position: originalPosition, size: size);
  @override
  FutureOr<void> onLoad() async {
    sprite = SpriteComponent(
        sprite: await Sprite.load(src),
        size: Vector2(455.3.w, 256.w),
        position: -originalPosition + (extraPosition ?? Vector2.zero()));
    add(sprite);
    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isGoal) {
      position += event.localDelta;
    }
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) async {
    isGoal = goal(position);
    if (isGoal) {
      sprite
        ..sprite = await Sprite.load(changedSrc)
        ..position = -originalPosition + (extraPosition ?? Vector2.zero());
    }
    position = originalPosition;
    super.onDragEnd(event);
  }
}

class ClickableSprite extends PositionComponent with TapCallbacks {
  Function(Vector2 position, PositionComponent sprite) onClickEvent;
  String src;
  Vector2? extraPosition;
  late SpriteComponent sprite;

  ClickableSprite(
      {required Vector2 position,
      this.extraPosition,
      required super.size,
      required this.onClickEvent,
      required this.src})
      : super(position: position);

  @override
  FutureOr<void> onLoad() async {
    sprite = SpriteComponent(
        sprite: await Sprite.load(src),
        position: -position + (extraPosition ?? Vector2.zero()),
        size: Vector2(455.3.w, 256.w));
    add(sprite);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    onClickEvent(event.canvasPosition, this);
    super.onTapUp(event);
  }
}

class ClickablePolygon extends PolygonComponent with TapCallbacks {
  Function onClickEvent;
  late Vector2 parentSize;

  ClickablePolygon(super._vertices, {required this.onClickEvent});

  ClickablePolygon.relative(super.vertices,
      {required this.onClickEvent, required super.parentSize})
      : super.relative();

  @override
  void onTapDown(TapDownEvent event) {
    onClickEvent();
    super.onTapDown(event);
  }
}

class Scroller extends PositionComponent with DragCallbacks, KeyboardHandler {
  PositionComponent scrollView;
  double scrollPosition = 0;

  Scroller({required this.scrollView})
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
    scrollView.position.x = -scrollPosition * 2090 / 989;
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
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      scrollPosition = max(0.w, scrollPosition - 20.w);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      scrollPosition = min(989.w / 3, scrollPosition + 20.w);
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
