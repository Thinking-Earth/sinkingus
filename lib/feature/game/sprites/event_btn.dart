import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/mini_game/custom_mini_game_dialog.dart';

abstract class EventBtn extends RectangleComponent with TapCallbacks {
  late String btnName = "";
  late TextComponent tempText = TextComponent();
  late Widget dialogContent;

  @override
  Paint get paint => BasicPalette.red.paint()..style = PaintingStyle.stroke;

  @override
  Anchor get anchor => Anchor.center;

  @override
  FutureOr<void> onLoad() {
    tempText.text = btnName;
    add(tempText);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (btnName == "plug off") {
      MiniGameDialog.plugOff();
    } else if (btnName == "buy necessity") {
      MiniGameDialog.buyNecessity();
    }
    print("$btnName : pop up!!!!");
    // TODO: popup show with dialogContent (@오종현)
  }
}

class BuyNecessityBtn extends EventBtn {
  // TODO: set position & size when design set
  // 상위에서 안받고 그냥 여기서 수치 넣기
  BuyNecessityBtn(Vector2 position) {
    this.position = position;
    size = Vector2(300, 200);
  }

  @override
  String get btnName => "buy necessity";

  @override
  // TODO: implement dialogContent (@오종현)
  Widget get dialogContent => super.dialogContent;
}

class NationalAssemblyBtn extends EventBtn {
  NationalAssemblyBtn(Vector2 position) {
    this.position = position;
    size = Vector2(300, 200);
  }

  @override
  String get btnName => "national assembly";

  @override
  // TODO: implement dialogContent (@오종현)
  Widget get dialogContent => super.dialogContent;
}

class PlugOffGameBtn extends EventBtn {
  PlugOffGameBtn(Vector2 position) {
    this.position = position;
    size = Vector2(300, 200);
  }

  @override
  String get btnName => "plug off";

  @override
  // TODO: implement dialogContent (@오종현)
  Widget get dialogContent => super.dialogContent;
}

class SunPowerGameBtn extends EventBtn {
  SunPowerGameBtn(Vector2 position) {
    this.position = position;
    size = Vector2(300, 200);
  }

  @override
  String get btnName => "sun power";

  @override
  // TODO: implement dialogContent (@오종현)
  Widget get dialogContent => super.dialogContent;
}

class WindPowerGameBtn extends EventBtn {
  WindPowerGameBtn(Vector2 position) {
    this.position = position;
    size = Vector2(300, 200);
  }

  @override
  String get btnName => "wind power";

  @override
  // TODO: implement dialogContent (@오종현)
  Widget get dialogContent => super.dialogContent;
}

class TrashGameBtn extends EventBtn {
  TrashGameBtn(Vector2 position) {
    this.position = position;
    size = Vector2(300, 200);
  }

  @override
  String get btnName => "trash";

  @override
  // TODO: implement dialogContent (@오종현)
  Widget get dialogContent => super.dialogContent;
}

class TreeGameBtn extends EventBtn {
  TreeGameBtn(Vector2 position) {
    this.position = position;
    size = Vector2(300, 200);
  }

  @override
  String get btnName => "tree";

  @override
  // TODO: implement dialogContent (@오종현)
  Widget get dialogContent => super.dialogContent;
}

class WaterOffGameBtn extends EventBtn {
  WaterOffGameBtn(Vector2 position) {
    this.position = position;
    size = Vector2(300, 200);
  }

  @override
  String get btnName => "water off";

  @override
  // TODO: implement dialogContent (@오종현)
  Widget get dialogContent => super.dialogContent;
}
