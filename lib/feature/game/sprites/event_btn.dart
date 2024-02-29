import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/mini_game/plug_off_game.dart';
import 'package:sinking_us/feature/game/mini_game/wind_power_game.dart';
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
      ..paint = (BasicPalette.yellow.paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10.0));
    add(stroke);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    ShowDialogHelper.gameEventDialog(title: type.name, widget: dialogWidget);
  }
}

class PlugOffBtn extends EventBtn {
  PlugOffBtn(
      {required super.vertices, required super.position, required super.size}) {
    final game = PlugOffGame();
    type = GameEventType.plugOff;
    dialogWidget = GameWidget(
      game: game,
    );
  }
}

class WindPowerBtn extends EventBtn {
  WindPowerBtn(
      {required super.vertices, required super.position, required super.size}) {
    final game = WindPowerGame();
    type = GameEventType.windPower;
    dialogWidget = GameWidget(game: game);
  }
}
