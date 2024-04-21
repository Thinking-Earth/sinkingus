library window_listener;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'window_listener_stub.dart'
    if (dart.library.html) 'window_listener_web.dart';

abstract class WindowListener {
  void onBeforeUnload(WidgetRef ref);
}

WindowListener getWindowListener() => getListener();