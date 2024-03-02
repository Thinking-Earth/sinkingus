import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/mini_game/plug_off_game.dart';
import 'package:sinking_us/feature/game/mini_game/sun_power_game.dart';
import 'package:sinking_us/feature/game/mini_game/trash_game.dart';
import 'package:sinking_us/feature/game/mini_game/tree_game.dart';
import 'package:sinking_us/feature/game/mini_game/water_off_game.dart';
import 'package:sinking_us/feature/game/mini_game/wind_power_game.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
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

abstract class EventBtn extends PositionComponent with RiverpodComponentMixin {
  late GameEventType type;
  late Widget dialogWidget;
  late TextComponent tempText = TextComponent();
  List<Vector2> vertices = [];

  EventBtn(
      {required List<Vector2> vertices,
      required Vector2 position,
      required Vector2 size})
      : super(position: position, size: size) {
    anchor = Anchor.center;
    final stroke = ClickablePolygon.relative(vertices, parentSize: size,
        onClickEvent: () {
      ShowDialogHelper.gameEventDialog(title: type.name, widget: dialogWidget);
    })
      ..paint = (BasicPalette.yellow.paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10.0));
    add(stroke);
  }
}

class PlugOffBtn extends EventBtn {
  PlugOffBtn({required super.position, required super.size})
      : super(vertices: [
          Vector2(-1, -1),
          Vector2(-1, 1),
          Vector2(1, 1),
          Vector2(1, -1)
        ]) {
    final game = PlugOffGame();
    type = GameEventType.plugOff;
    dialogWidget = GameWidget(
      game: game,
    );
  }
}

class WindPowerBtn extends EventBtn {
  WindPowerBtn({required super.position, required super.size})
      : super(vertices: [
          Vector2(0.258, -0.369),
          Vector2(0.258, -0.493),
          Vector2(1, -1),
          Vector2(0.393, -0.328),
          Vector2(0.483, -0.246),
          Vector2(0.910, 0.287),
          Vector2(0.865, 0.315),
          Vector2(0.258, -0.137),
          Vector2(0.236, -0.26),
          Vector2(0.169, -0.26),
          Vector2(0.191, 0.973),
          Vector2(-0.101, 0.973),
          Vector2(0.0112, -0.205),
          Vector2(-1.0, -0.26),
          Vector2(0.101, -0.438),
        ]) {
    final game = WindPowerGame();
    type = GameEventType.windPower;
    dialogWidget = GameWidget(game: game);
  }
}

class TrashBtn extends EventBtn {
  TrashBtn({required super.position, required super.size})
      : super(vertices: [
          Vector2(-0.02, -0.5),
          Vector2(0.5, -1.07),
          Vector2(1.05, -0.214),
          Vector2(1.0, 0.18),
          Vector2(0.25, 0.929),
          Vector2(0.0, 0.929),
          Vector2(-0.9, 0.55),
          Vector2(-1.0, 0.0714),
          Vector2(-0.75, -0.643),
          Vector2(-0.4, -0.643),
        ]) {
    final game = TrashGame();
    type = GameEventType.trash;
    dialogWidget = GameWidget(game: game);
  }
}

class SunPowerBtn extends EventBtn {
  SunPowerBtn({required super.position, required super.size})
      : super(vertices: [
          Vector2(-0.867, -0.565),
          Vector2(1.0, -0.957),
          Vector2(1.0, 0.565),
          Vector2(-0.867, 0.957),
        ]) {
    final game = SunPowerGame();
    type = GameEventType.sunPower;
    dialogWidget = game;
  }
}

class WaterOffBtn extends EventBtn {
  WaterOffBtn({required super.position, required super.size})
      : super(vertices: [
          Vector2(-0.882, -1.0),
          Vector2(0.843, -1.0),
          Vector2(1.0, -0.515),
          Vector2(1.0, 0.212),
          Vector2(0.765, 0.697),
          Vector2(0.333, 1.0),
          Vector2(-0.373, 1.0),
          Vector2(-0.765, 0.636),
          Vector2(-1.0, 0.212),
          Vector2(-1.0, -0.515),
        ]) {
    final game = WaterOffGame();
    type = GameEventType.waterOff;
    dialogWidget = GameWidget(game: game);
  }
}

class TreeBtn extends EventBtn {
  TreeBtn({required super.position, required super.size})
      : super(vertices: [
          Vector2(-0.805, -0.897),
          Vector2(-0.0732, -0.276),
          Vector2(0.171, -0.448),
          Vector2(-0.0732, -0.655),
          Vector2(0.122, -0.655),
          Vector2(0.171, -0.897),
          Vector2(0.366, -0.655),
          Vector2(1.0, -0.931),
          Vector2(0.463, -0.414),
          Vector2(0.268, 0.172),
          Vector2(0.268, 0.517),
          Vector2(0.561, 0.966),
          Vector2(0.171, 0.862),
          Vector2(-0.0732, 1.03),
          Vector2(-0.268, 0.862),
          Vector2(-0.756, 0.966),
          Vector2(-0.412, 0.414),
          Vector2(-0.366, -0.103),
          Vector2(-0.512, -0.276),
          Vector2(-0.951, -0.345),
          Vector2(-0.61, -0.483),
          Vector2(-0.854, -0.759),
        ]) {
    final game = TreeGame();
    type = GameEventType.tree;
    dialogWidget = GameWidget(game: game);
  }
}
