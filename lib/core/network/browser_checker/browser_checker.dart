library browser_checker;

export 'browser_stub.dart'
  if (dart.library.html) 'browser_checker_web.dart';