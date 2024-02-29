import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

enum GameEventType {
  buyNecessity(-1, "Buy Necessity"),
  nationalAssembly(-2, "National Assembly"),
  plugOff(0, "Plug Off"),
  sunPower(1, "Sun Power"),
  windPower(2, "Wind Power"),
  trash(3, "Trash"),
  tree(4, "Tree"),
  waterOff(5, "Water Off");

  const GameEventType(this.jsonIndex, this.name);
  final int jsonIndex;
  final String name;
}

abstract class EventBtn extends PositionComponent
    with TapCallbacks, RiverpodComponentMixin {
  late GameEventType type;
  late Widget dialogWidget;
  late TextComponent tempText = TextComponent();

  EventBtn(
      {required List<Vector2> vertices,
      required Vector2 position,
      required Vector2 size})
      : super(position: position, size: size) {
    anchor = Anchor.center;
    final stroke = PolygonComponent.relative(vertices, parentSize: size)
      ..paint = BasicPalette.red.paint();
    add(stroke);
  }

  @override
  Anchor get anchor => Anchor.topLeft;

  @override
  FutureOr<void> onLoad() {
    tempText.text = type.name;
    add(tempText);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    ShowDialogHelper.gameEventDialog(title: type.name, widget: dialogWidget);
  }
}

class PlugOffGame extends FlameGame {
  @override
  FutureOr<void> onLoad() async {
    SpriteComponent background =
        SpriteComponent(sprite: await Sprite.load("minigame/plug/pop up.jpg"));
    add(background);
    return super.onLoad();
  }
}

class PlugOffBtn extends EventBtn {
  PlugOffBtn(
      {required super.vertices, required super.position, required super.size}) {
    final game = PlugOffGame();
    type = GameEventType.plugOff;
    dialogWidget = Container(
        width: 100.w,
        height: 100.h,
        child: GameWidget(
          game: game,
        ));
  }
}
