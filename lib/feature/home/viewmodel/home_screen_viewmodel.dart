import 'package:flame/game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/game/mini_game/sun_power_game.dart';
import 'package:sinking_us/feature/game/mini_game/tree_game.dart';
import 'package:sinking_us/feature/game/mini_game/water_off_game.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'home_screen_viewmodel.g.dart';

class HomeScreenState {
  HomeScreenState();
}

@riverpod
class HomeScreenController extends _$HomeScreenController {
  @override
  HomeScreenState build() {
    return HomeScreenState();
  }

  void setState() {
    state = HomeScreenState();
  }

  void handlePressedBuildRoom() {
    final game = TreeGame();
    // ShowDialogHelper.gameEventDialog(
    //     title: "sun power", widget: GameWidget(game: game));
    ShowDialogHelper.showBuildRoomDialog();
  }

  void handlePressedSearchRoom() {
    ShowDialogHelper.showSearchRoomDialog();
  }
}
