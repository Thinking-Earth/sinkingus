import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
  Vector2? spriteSize;
  late SpriteComponent sprite;

  ClickableSprite(
      {required Vector2 position,
      this.extraPosition,
      this.spriteSize,
      required super.size,
      required this.onClickEvent,
      required this.src})
      : super(position: position);

  @override
  FutureOr<void> onLoad() async {
    sprite = SpriteComponent(
        sprite: await Sprite.load(src),
        position: -position + (extraPosition ?? Vector2.zero()),
        size: spriteSize ?? Vector2(455.3.w, 256.w));
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
