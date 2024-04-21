import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sinking_us/core/network/browser_checker/browser_checker.dart';
import 'package:sinking_us/core/network/firestore_base.dart';
import 'package:sinking_us/firebase_options.dart';
import 'package:sinking_us/main.dart';
import 'package:url_strategy/url_strategy.dart';

class AppBootstrapper {
  const AppBootstrapper._();

  static Future<void> init({
    required void Function(Widget) runApp,
  }) async {
    setPathUrlStrategy();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await EasyLocalization.ensureInitialized();
    FirestoreBase.init();
    browserChecker();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'), 
          Locale('ko', 'KR'), 
          Locale('ja', 'JP'),
          Locale('vi', 'VN'),
          Locale('zh', 'CN'),
          Locale('es', 'ES')
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: SinkingUs(idToken: "test",)
      )
    );
  }
}