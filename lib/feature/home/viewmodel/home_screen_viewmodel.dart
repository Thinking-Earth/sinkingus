import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'home_screen_viewmodel.g.dart';

class HomeScreenState {
  HomeScreenState({required this.bottomText});

  String bottomText;
}

@riverpod
class HomeScreenController extends _$HomeScreenController {
  @override
  HomeScreenState build() {
    return HomeScreenState(
      bottomText: tr('game_description')
    );
  }

  void setState() {
    state = HomeScreenState(
      bottomText: state.bottomText
    );
  }

  void handlePressedBuildRoom() {
    ShowDialogHelper.showBuildRoomDialog();
  }

  void handlePressedSearchRoom() {
    ShowDialogHelper.showSearchRoomDialog();
  }

  void handleBottomText(String content) {
    state.bottomText = content;
    setState();
  }

  void handleSetting() {
    ShowDialogHelper.showSettingDialog();
  }
}
