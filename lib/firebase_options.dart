// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
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
    apiKey: 'AIzaSyDNt4OKcPn49IAi1OAEVb-aVT1YFBFZXHU',
    appId: '1:163865342854:web:d780f87a2a0af5e590b207',
    messagingSenderId: '163865342854',
    projectId: 'fir-chat-b1198',
    authDomain: 'fir-chat-b1198.firebaseapp.com',
    storageBucket: 'fir-chat-b1198.firebasestorage.app',
    measurementId: 'G-ZJTYC1Z17P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7ga1W-2j-FGDKPnBONMIBCsk8Mozc0TA',
    appId: '1:163865342854:android:58433972ea6e68c790b207',
    messagingSenderId: '163865342854',
    projectId: 'fir-chat-b1198',
    storageBucket: 'fir-chat-b1198.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCtzYLujF2vM8hyJ4IRsd5210U-G0YA0Fk',
    appId: '1:163865342854:ios:c0787eaff67ca8bd90b207',
    messagingSenderId: '163865342854',
    projectId: 'fir-chat-b1198',
    storageBucket: 'fir-chat-b1198.firebasestorage.app',
    iosBundleId: 'com.example.chat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCtzYLujF2vM8hyJ4IRsd5210U-G0YA0Fk',
    appId: '1:163865342854:ios:c0787eaff67ca8bd90b207',
    messagingSenderId: '163865342854',
    projectId: 'fir-chat-b1198',
    storageBucket: 'fir-chat-b1198.firebasestorage.app',
    iosBundleId: 'com.example.chat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDNt4OKcPn49IAi1OAEVb-aVT1YFBFZXHU',
    appId: '1:163865342854:web:599084046c162b2990b207',
    messagingSenderId: '163865342854',
    projectId: 'fir-chat-b1198',
    authDomain: 'fir-chat-b1198.firebaseapp.com',
    storageBucket: 'fir-chat-b1198.firebasestorage.app',
    measurementId: 'G-1WFNFZY84F',
  );
}
