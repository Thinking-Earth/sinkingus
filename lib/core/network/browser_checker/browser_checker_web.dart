import 'dart:html' as html;

import 'package:easy_localization/easy_localization.dart';

void browserChecker() {
  final String userAgent = html.window.navigator.userAgent.toLowerCase();
  final String alertText = tr('noti_browser_check');
  if (!userAgent.contains('chrome')) {
    html.window.alert(alertText);
  }
}