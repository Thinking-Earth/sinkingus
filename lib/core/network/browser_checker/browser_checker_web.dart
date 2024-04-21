import 'dart:html' as html;

import 'package:easy_localization/easy_localization.dart';

void browserChecker() {
  String userAgent = html.window.navigator.userAgent.toLowerCase();
  if (!userAgent.contains('chrome')) {
    html.window.alert(tr('noti_browser_check'));
  }
}