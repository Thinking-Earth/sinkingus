import 'package:flame/game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/game/mini_game/buy_necessity_dialog.dart';
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
    // TODO: 이 부분을 주석 해제하고 맨 아랫줄을 주석처리하면 테스트 가능 (@오종현)
    final game = BuyNecessityDialog();
    ShowDialogHelper.gameEventDialog(
        text: "sun power", widget: GameWidget(game: game));
    //ShowDialogHelper.showBuildRoomDialog();
  }

  void handlePressedSearchRoom() {
    ShowDialogHelper.showSearchRoomDialog();
  }
}
