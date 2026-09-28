import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
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
    apiKey: 'AIzaSyBm9Zy9LmEgG3FZFQSOu-wvgyyURr9AlRo',
    appId: '1:551155728334:web:43896bd99919efad75b59f',
    messagingSenderId: '551155728334',
    projectId: 'fandom-verse-c82de',
    authDomain: 'fandom-verse-c82de.firebaseapp.com',
    storageBucket: 'fandom-verse-c82de.firebasestorage.app',
    measurementId: 'G-CJNWVKF0PQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClfOvS-7lnyy9cujD1tLvKGuFkLDxwDKo',
    appId: '1:551155728334:android:6bd5e7c3d398b9e675b59f',
    messagingSenderId: '551155728334',
    projectId: 'fandom-verse-c82de',
    storageBucket: 'fandom-verse-c82de.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcpJlJ1w1inbA2Dwi1Kyrx-4kbf0qgrYU',
    appId: '1:551155728334:ios:eeacbc729696df5375b59f',
    messagingSenderId: '551155728334',
    projectId: 'fandom-verse-c82de',
    storageBucket: 'fandom-verse-c82de.firebasestorage.app',
    iosBundleId: 'com.example.fandomVerse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCcpJlJ1w1inbA2Dwi1Kyrx-4kbf0qgrYU',
    appId: '1:551155728334:ios:eeacbc729696df5375b59f',
    messagingSenderId: '551155728334',
    projectId: 'fandom-verse-c82de',
    storageBucket: 'fandom-verse-c82de.firebasestorage.app',
    iosBundleId: 'com.example.fandomVerse',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBm9Zy9LmEgG3FZFQSOu-wvgyyURr9AlRo',
    appId: '1:551155728334:web:6fb3825b161b3e1c75b59f',
    messagingSenderId: '551155728334',
    projectId: 'fandom-verse-c82de',
    authDomain: 'fandom-verse-c82de.firebaseapp.com',
    storageBucket: 'fandom-verse-c82de.firebasestorage.app',
    measurementId: 'G-CP2Y2TCJT7',
  );
}