import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/home/view/build_room_dialog.dart';
import 'package:sinking_us/feature/home/view/search_room_dialog.dart';
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
    ShowDialogHelper.showRoomDialog(
        title: "Build Room", widget: BuildDialogContent());
  }

  void handlePressedSearchRoom() {
    ShowDialogHelper.showRoomDialog(
        title: "Search Room", widget: SearchDialogContent());
  }
}
