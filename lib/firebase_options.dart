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
    apiKey: 'AIzaSyCxQHWwVlbMFTdzQlz3PPdx-RfZ8LtzCnk',
    appId: '1:891998389906:web:2596ecb75a1f48cbd1084b',
    messagingSenderId: '891998389906',
    projectId: 'chat-f3a39',
    authDomain: 'chat-f3a39.firebaseapp.com',
    storageBucket: 'chat-f3a39.firebasestorage.app',
    measurementId: 'G-YXJ5MN5FEJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFu0ptg4WO89Q1w34PuL3H-SnIUSe1g34',
    appId: '1:891998389906:android:ce8d6a0592a22cfbd1084b',
    messagingSenderId: '891998389906',
    projectId: 'chat-f3a39',
    storageBucket: 'chat-f3a39.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDlAwmAj9n9c9-GX1pDHIAK5eWZLl84aY',
    appId: '1:891998389906:ios:5f0e8abf9bdf97f4d1084b',
    messagingSenderId: '891998389906',
    projectId: 'chat-f3a39',
    storageBucket: 'chat-f3a39.firebasestorage.app',
    iosBundleId: 'com.example.chatFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDlAwmAj9n9c9-GX1pDHIAK5eWZLl84aY',
    appId: '1:891998389906:ios:5f0e8abf9bdf97f4d1084b',
    messagingSenderId: '891998389906',
    projectId: 'chat-f3a39',
    storageBucket: 'chat-f3a39.firebasestorage.app',
    iosBundleId: 'com.example.chatFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCxQHWwVlbMFTdzQlz3PPdx-RfZ8LtzCnk',
    appId: '1:891998389906:web:d9d4b6f7a4b7699fd1084b',
    messagingSenderId: '891998389906',
    projectId: 'chat-f3a39',
    authDomain: 'chat-f3a39.firebaseapp.com',
    storageBucket: 'chat-f3a39.firebasestorage.app',
    measurementId: 'G-H6TGV2GW1D',
  );
}