import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    ShowDialogHelper.showBuildRoomDialog(title: "Build Room");
  }

  void handlePressedSearchRoom() {
    ShowDialogHelper.showSearchRoomDialog(title: "Search Room");
  }
}
