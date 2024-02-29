import 'package:flutter/material.dart';
import 'package:sinking_us/feature/game/mini_game/dialog_buy_necessity.dart';
import 'package:sinking_us/feature/game/mini_game/dialog_plugoff.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

@immutable
class MiniGameDialog {
  const MiniGameDialog._();

  static void buyNecessity() {
    ShowDialogHelper.gameEventDialog(
        title: "Buy Necessity", widget: buyNecessityWidget());
  }

  static void plugOff() {
    ShowDialogHelper.gameEventDialog(
        title: "Plug OFF", widget: plugOffWidget());
  }
}
