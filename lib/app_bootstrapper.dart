import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sinking_us/core/local/local_storage_base.dart';
import 'package:sinking_us/core/network/firestore_base.dart';
import 'package:sinking_us/core/network/network_status.dart';
import 'package:sinking_us/firebase_options.dart';
import 'package:sinking_us/main.dart';
import 'package:url_strategy/url_strategy.dart';

class AppBootstrapper {
  const AppBootstrapper._();

  static Future<void> init({
    required void Function(Widget) runApp,
  }) async {
    setPathUrlStrategy();
    await LocalStorageBase.init();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await EasyLocalization.ensureInitialized();
    FirestoreBase.init();
    NetWorkStatusManagement.init();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR'), Locale('ja', 'JP')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: SinkingUs(idToken: "test",)
      )
    );
  }
}