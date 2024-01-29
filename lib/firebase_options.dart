import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7OfcM8uH8NjbTxxrgwpoCNlYlxeQNZw4',
    appId: '1:57185542814:web:5387b9d6246c6265a6118f',
    messagingSenderId: '57185542814',
    projectId: 'sinkingus',
    authDomain: 'sinkingus.firebaseapp.com',
    databaseURL: 'https://sinkingus-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sinkingus.appspot.com',
    measurementId: 'G-VKCG3K279F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBT9mllcD78Scg2Kkpa50ZWXq3RZBeG5UY',
    appId: '1:57185542814:android:a38196ab40083744a6118f',
    messagingSenderId: '57185542814',
    projectId: 'sinkingus',
    databaseURL: 'https://sinkingus-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sinkingus.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCg7My0JHNtmNadcmGNyK-5VZXq3l9P1hs',
    appId: '1:57185542814:ios:ac8d453a60594aa5a6118f',
    messagingSenderId: '57185542814',
    projectId: 'sinkingus',
    databaseURL: 'https://sinkingus-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sinkingus.appspot.com',
    iosBundleId: 'com.thinking.earth.sinkingUs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCg7My0JHNtmNadcmGNyK-5VZXq3l9P1hs',
    appId: '1:57185542814:ios:518a7ef11ac88f8da6118f',
    messagingSenderId: '57185542814',
    projectId: 'sinkingus',
    databaseURL: 'https://sinkingus-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sinkingus.appspot.com',
    iosBundleId: 'com.thinking.earth.sinkingUs.RunnerTests',
  );
}
