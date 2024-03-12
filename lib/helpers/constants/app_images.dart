import 'package:flutter/material.dart';

const String basePath = "assets/images";

@immutable
class AppImages {
  const AppImages._();

  static const String homeBg = '$basePath/home/home_bg.png';
  static const String refreshIcon = '$basePath/home/refresh_icon.png';
  static const String gameBlockBtn = '$basePath/home/game_block_btn.png';

  static const String searchPopUp = '$basePath/home/search_popup.png';
  static const String roomName = '$basePath/home/room_name.png';
  static const String gameListTile = '$basePath/home/game_list_tile.png';
  static const String searchBtn = '$basePath/home/search_btn.png';
  static const String searchIcon = '$basePath/home/search_icon.png';
  static const String listTile = '$basePath/home/list_tile.png';

  static const String businessMan = '$basePath/characters/business_idle.png';
  static const String natureMan = '$basePath/characters/nature_idle.png';
  static const String politicianMan = '$basePath/characters/politician_idle.png';
  static const String workerMan = '$basePath/characters/worker_idle.png';
}
