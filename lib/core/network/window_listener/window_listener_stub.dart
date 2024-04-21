import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinking_us/core/network/window_listener/window_listener.dart';

class MobileWindowListener implements WindowListener {
  @override
  void onBeforeUnload(WidgetRef ref) {
  }
}

WindowListener getListener() => MobileWindowListener();