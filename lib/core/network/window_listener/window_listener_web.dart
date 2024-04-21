import 'dart:html' as html;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinking_us/core/network/window_listener/window_listener.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';

class WebWindowListener implements WindowListener {
  @override
  void onBeforeUnload(WidgetRef ref) {
    html.window.onBeforeUnload.listen((event) {
      if (event is html.BeforeUnloadEvent) {
        ref.read(matchDomainControllerProvider.notifier).leaveMatch();
      }
    });
  }
}

WindowListener getListener() => WebWindowListener();