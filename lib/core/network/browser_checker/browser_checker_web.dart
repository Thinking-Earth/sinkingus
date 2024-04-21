import 'dart:html' as html;

import 'package:easy_localization/easy_localization.dart';

void browserChecker() {
  final String userAgent = html.window.navigator.userAgent.toLowerCase();
  // if(userAgent.contains('mobile')) {
  //   html.window.alert(tr('settingPage_downloadAPP'));
  // }
  if (!userAgent.contains('chrome') || ['kakaotalk', 'naver', 'whale', 'everytimeapp'].any((browser) => userAgent.contains(browser))) {
    html.window.alert(tr('noti_browser_check'));
  }
}