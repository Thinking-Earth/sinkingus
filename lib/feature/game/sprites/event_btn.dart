import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/mini_game/buy_necessity_dialog.dart';
import 'package:sinking_us/feature/game/mini_game/select_policy_dialog.dart';
import 'package:sinking_us/feature/game/mini_game/plug_off_game.dart';
import 'package:sinking_us/feature/game/mini_game/sun_power_game.dart';
import 'package:sinking_us/feature/game/mini_game/trash_game.dart';
import 'package:sinking_us/feature/game/mini_game/tree_game.dart';
import 'package:sinking_us/feature/game/mini_game/water_off_game.dart';
import 'package:sinking_us/feature/game/mini_game/wind_power_game.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';
import 'package:sinking_us/feature/game/sprites/sprite_util.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

enum GameEventType {
  plugOff(0),
  sunPower(1),
  windPower(2),
  trash(3),
  tree(4),
  waterOff(5),
  buyNecessity(6),
  nationalAssembly(7),
  news(8),
  undefined(-1);

  const GameEventType(this.id);
  final int id;
}

abstract class EventBtn extends PositionComponent
    with RiverpodComponentMixin, HasGameReference<SinkingUsGame> {
  late GameEventType type;
  late Widget dialogWidget;
  late TextComponent tempText = TextComponent();
  List<Vector2> vertices = [];

  EventBtn(
      {required List<Vector2> vertices,
      required super.position,
      required super.size})
      : super() {
    anchor = Anchor.center;
    final stroke = ClickablePolygon.relative(vertices,
        parentSize: size, isBtn: true, onClickEvent: () {
      if (type.id < 6) {
        FirebaseDatabase.instance
            .ref("game/${game.matchId}/gameEventList/${type.id}")
            .once()
            .then((value) {
          if (value.snapshot.value as int == 0) {
            game.state.currentEvent = type.index;
            ShowDialogHelper.gameEventDialog(
                    text: type.name, widget: dialogWidget)
                .then((value) {
              game.state.currentEvent = GameEventType.undefined.id;
              if (value) onEventEnd();
            });
          } else {
            ShowDialogHelper.showSnackBar(content: tr("mission_already_done"));
          }
        });
      } else {
        game.state.currentEvent = type.index;
        ShowDialogHelper.gameEventDialog(text: type.name, widget: dialogWidget)
            .then((value) {
          game.state.currentEvent = GameEventType.undefined.id;
        });
      }
    })
      ..paint = (BasicPalette.yellow.paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10.0));
    add(stroke);
  }

  void onEventEnd() async {
    bool result = await solvedMinigame();
    if (result) {
      int moneydt = 50;
      int natureScoredt = 0;
      if (game.player.role == RoleType.nature) {
        natureScoredt =
            min(game.state.natureScore + 30, 100) - game.state.natureScore;
      }
      ref
          .read(matchDomainControllerProvider.notifier)
          .setDt(0, natureScoredt, moneydt);
      FlameAudio.play("income.mp3");
    } else {
      ShowDialogHelper.showSnackBar(content: tr("mission_already_done"));
    }
  }

  Future<bool> solvedMinigame() async {
    final result = await FirebaseDatabase.instance
        .ref("game/${game.matchId}/gameEventList/${type.id}")
        .get()
        .then((value) {
      if (!value.exists) return false;
      if (value.value == 1) return false;
      return true;
    });

    if (!result) return false;

    await FirebaseDatabase.instance
        .ref("game/${game.matchId}/gameEventList/${type.id}")
        .set(1);

    return true;
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
    final minigame = PlugOffGame();
    type = GameEventType.plugOff;
    dialogWidget = GameWidget(
      game: minigame,
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
    final minigame = WindPowerGame();
    type = GameEventType.windPower;
    dialogWidget = GameWidget(game: minigame);
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
    final minigame = TrashGame();
    type = GameEventType.trash;
    dialogWidget = GameWidget(game: minigame);
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
    const minigame = SunPowerGame();
    type = GameEventType.sunPower;
    dialogWidget = minigame;
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
    final minigame = WaterOffGame();
    type = GameEventType.waterOff;
    dialogWidget = GameWidget(game: minigame);
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
    final minigame = TreeGame();
    type = GameEventType.tree;
    dialogWidget = GameWidget(game: minigame);
  }
}

class BuyNecessityBtn extends EventBtn {
  BuyNecessityBtn({required super.position, required super.size})
      : super(vertices: [
          Vector2(-1, -1),
          Vector2(1, -1),
          Vector2(1, 1),
          Vector2(-1, 1)
        ]);

  @override
  FutureOr<void> onLoad() {
    final dialog = BuyNecessityDialog(state: game.state);
    type = GameEventType.buyNecessity;

    dialogWidget = GameWidget(game: dialog);
    return super.onLoad();
  }

  @override
  void onEventEnd() {}
}

class PolicyBtn extends EventBtn {
  PolicyBtn({required super.position, required super.size})
      : super(vertices: [
          Vector2(-1.0, -1.0),
          Vector2(-0.892, -1.0),
          Vector2(-0.711, -0.743),
          Vector2(-0.325, -0.545),
          Vector2(0.325, -0.545),
          Vector2(0.59, -0.644),
          Vector2(0.916, -1.0),
          Vector2(1.01, -1.0),
          Vector2(1.0, 0.624),
          Vector2(0.928, 0.644),
          Vector2(0.747, 0.822),
          Vector2(0.41, 1.02),
          Vector2(-0.398, 1.02),
          Vector2(-0.699, 0.822),
          Vector2(-0.916, 0.644),
          Vector2(-1.0, 0.624),
        ]);

  @override
  FutureOr<void> onLoad() {
    final dialog = PolicyDialog(state: game.state);
    type = GameEventType.nationalAssembly;

    dialogWidget = GameWidget(game: dialog);
    return super.onLoad();
  }

  @override
  void onEventEnd() {}
}
